# SmartContracts
This repository contains the prototypes of some of the smart contracts that will be used by SaharaChain ecosystem.

# List of contracts:
## ProfitDistributorToken
This is a prototype of the token that will be used by SaharaChain to distribute 20% of the transaction fees to the token holders. The token is ERC20 compatible.

The profit distributing mecanism is mainly in two functions:
*distributeProfit*: this function is called by SaharaChain in a transaction with ether = (total tokens * profit per token).
                    the parameters of this function is the Wei per token (wpt).
                    
*claimProfit*: this function is called by token holders. The function transfers the holder's share of the profits, if there's any, to his/her address.

When a user transfer his/her tokens to another user, the unclaimed profits, if there are any, are not transferred and they are claimable by calling claimProfit.
