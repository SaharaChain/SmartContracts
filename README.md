# About the project
SaharaChain ecosystem is a set of products aimed at enabling and facilitating the blockchain technology in the Middle East and North Africa. The details of the project can be found at https://SaharaChain.com.

# SmartContracts
This repository contains the prototypes of some of the smart contracts that will be used by SaharaChain ecosystem.

# List of contracts:
## IncentivesDistributorToken
This is a prototype of the token that will be used by SaharaChain to distribute 20% of the transaction fees to the token holders. The token is ERC20 compatible.

The incentives distributing mechanism is mainly in two functions:

**distributeIncentives**: this function is called by SaharaChain in a transaction with ether = (total tokens * incentives per token).
                    the parameters of this function is the Wei per token (wpt).
                    
**claimIncentives**: this function is called by token holders. The function transfers the holder's share of the incentives, if there's any, to his/her address.

When a user transfer his/her tokens to another user, the unclaimed incentives, if there are any, are not transferred and they are claimable by calling claimIncentives.

# License
Copyright 2017, https://SaharaChain.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
