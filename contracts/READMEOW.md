# NFT Reward for Liquidity Mining

In this project we do a mockup of a 50-50 liquidity pool with ETH-YM1 and ETH-YM2 pairs. The total stakes is currently recorded as per amount of ETH for ease of implementation, and needs to be changed for a more complete implementation. 

The project consists of the following contract:
* KleeMineV1 -- the LP
* KleeRewardV2 -- the RewardLocker
* YM1 and YM2 -- the mockup coins
* KleeCoinV2 -- the native currency of the NFT (doesnt have exchange function, can only be used to buy NFT)
* KleeTokenV6 -- the NFT Rewards 

The order of set up is as followed:
1. Deploy all contracts
2. In KleeMineV1, 
   1. set setRewardLockerAddress( address of KleeRewardV2)
   2. addPool(0,address of YM1) -- 0 is eth, the native currency
   3. addPool(0,address of YM2) 
   4. do the initial staking of these 2 pools, -- we wont record the shares if it's initial stake for the pool. Make sure that it's 50-50. 
3. In KleeCoinV2,
   1. Transfer an initial amount of KV2 to the address of KleeRewardV2 for distribution of rewards

How it works:
1. User acquire their YM1 and YM2 in the various native coin address (DEX listing tbd)
2. User stake their amount of ETH-YM1 and/or ETH-YM2 in KleeMineV1, which will record their shares (which is percentage of eth they contributed)
3. RewardLocker implements a 3-tier contribution model, which gives higher rewards (KV2) to more stake tokens contributed to encourage LP. It also implements linear vesting with lock-up period of 2000s (for ease of demo).
4. After the lockup period, the user would have acquired an amount of native KV2 tokens, which they will then use to purchase different tier of NFT at KleeTokenV6. 


Certain design decisions and ongoing design decisions to be made:
1. The reward contract will only need to know about the number of shares the LP stake into the pools. Returning the initial staked amount is the LP job and not the Reward Contract job. Hence we have removed that info from Reward Contract. 
2. Should the NFT minting only be done by Owner -- up to discussion 
3. The Mine code is definitely wrong as of this writing (9 nov 21) 
