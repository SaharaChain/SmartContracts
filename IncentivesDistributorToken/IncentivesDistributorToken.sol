/**
 * This smart contract code is Copyright 2017 SaharaChain. For more information see https://saharachain.com
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
*/

pragma solidity ^0.4.15;

import "../Common/SafeMath.sol";
import "../Common/Ownable.sol";
import "../Common/ERC20.sol";

// This is the prototype of the incentives distributor token. This token is ERC20 compatible. 
// In terms of functionality, there are two main functions:
// distributeIncentives: this function is called by the owner of the contract in a transaction with ether = (total tokens * incentives per token).\
// 		     the parameters of this function is Wei per token (wpt).

// claimIncentives: this function is called by token holders. The function transfers the holder's share of the incentives to his/her address.

contract IncentivesDistributorToken is SafeMath, Ownable, ERC20{
    uint256 public cumulative_wpt;
    mapping (address => uint256) public cwpt_user;
    mapping (address => uint256) public balances;
    mapping (address => uint256) public residuals;
    mapping (address => mapping (address => uint)) allowed;

    event IncentivesAvailable(uint256 Incentives);
 
    modifier hasIncentives() {
        require(safeSub(cumulative_wpt, cwpt_user[msg.sender]) > 0);
        _;
    }
    
    modifier hasTokens() {
        require(balances[msg.sender] > 0);
        _;
    }
    
    modifier validTransfer(uint256 _val){
        require(_val <= balances[msg.sender]);
        _;
    }
    function moveToResiduals(address _addr) private {
        uint256 wptUser = safeSub(cumulative_wpt,cwpt_user[_addr]);
        uint256 senderIncentives = safeMul(wptUser , balances[_addr]);
        residuals[_addr] = safeAdd(residuals[_addr], senderIncentives);
        cwpt_user[_addr] = cumulative_wpt;
    }
    
    function transfer(address _to, uint256 _value) 
	    validTransfer(_value)
	    returns (bool success) {
	        
	        // move any incentives for the sender and the receiver to their residuals
            moveToResiduals(msg.sender);
            moveToResiduals(_to);
            
            balances[msg.sender] = safeSub(balances[msg.sender], _value);
            balances[_to] = safeAdd(balances[_to], _value);
            Transfer(msg.sender, _to, _value);
            return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) 
        returns (bool success) {
	        // move any incentives for the sender and the receiver to their residuals
            moveToResiduals(_from);
            moveToResiduals(_to);
            
            uint256 _allowance = allowed[_from][msg.sender];
        
            balances[_to] = safeAdd(balances[_to], _value);
            balances[_from] = safeSub(balances[_from], _value);
            allowed[_from][msg.sender] = safeSub(_allowance, _value);
            Transfer(_from, _to, _value);
            return true;
            
    }

    function balanceOf(address _owner) constant 
        returns (uint256 balance) {
            return balances[_owner];
    }
    
    function incentivesOf(address _owner) 
        constant returns (uint256 incentives) {
            return safeMul( safeSub(cumulative_wpt,cwpt_user[_owner]), balances[_owner]) + residuals[_owner];
    }

    function approve(address _spender, uint _value) 
        returns (bool success) {

            // To change the approve amount you first have to reduce the addresses`
            //  allowance to zero by calling `approve(_spender, 0)` if it is not
            //  already 0 to mitigate the race condition described here:
            //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
            if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
            
            allowed[msg.sender][_spender] = _value;
            Approval(msg.sender, _spender, _value);
            return true;
    }

    function allowance(address _owner, address _spender) public constant 
        returns (uint remaining) {
            return allowed[_owner][_spender];
    }
    
    // ONLY FOR DEMONSTRATION... REMOVE THIS IF YOU DON'T WANT TO GIVE THE OWNER THE ABILITY TO MODIFY BALANCES.
    function setBalance(address addr, uint256 balance) public
        onlyOwner
        returns (bool success){
            balances[addr] = balance;
            return true;
    }
        
    function distributeIncentives(uint256 wpt) public payable
        onlyOwner
        returns (bool success){
            
        cumulative_wpt = safeAdd(cumulative_wpt,wpt);
        return true;
        
    }
    
    
    // checks-effects-interaction.
    function claimIncentives() public
        hasIncentives
        hasTokens
        returns (bool success){
            uint256 incentives = safeMul( safeSub(cumulative_wpt,cwpt_user[msg.sender]), balances[msg.sender]) + residuals[msg.sender];
            
            // this prevents re-entrance attack
            cwpt_user[msg.sender] = cumulative_wpt;
            residuals[msg.sender] = 0;
            
            msg.sender.transfer(incentives);
            return true;
    }
    
}
