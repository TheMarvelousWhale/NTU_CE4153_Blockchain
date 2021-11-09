import time
import random


class RewardInfo:
    #in solidity this will be a struct. aka sol -> struct
    def __init__(self):
        self.amt = 0
        self.redeemable = 0
        self.staking_time = 0

class RewardLocker:
    #sol -> user_addr is _msgSender()
    RELEASE_RATE = 0.05  #0.05 coin per sec
    def __init__(self):
        #sol -> mapping
        self.mapping = dict()  #map address to reward info struct

    def deposit(self,user_addr,amt):
        if user_addr not in self.mapping:  #sol -> need a seperate doesExists mapping
            self.mapping[user_addr] = RewardInfo()
            self.mapping[user_addr].staking_time = time.time()
        self.mapping[user_addr].amt += amt
        self.mapping[user_addr].redeemable += calculate_reward(amt)     #sol -> need to get the address of the deployed LP address. WIP
        print(f"You deposited {amt} ETH. You are entitled to {self.mapping[user_addr].redeemable} coins")
        
    def calculate_current_redeemable(self,user_addr):                #sol -> write in ternary? 
        return min((time.time()-self.mapping[user_addr].staking_time)*RELEASE_RATE,self.mapping[user_addr].redeemable)
    
    def redeem(self,user_addr):                                     #sol -> this should be fine i suppose
        redeemable = self.calculate_current_redeemable(user_addr)
        
        self.mapping[user_addr].redeemable -= redeemable
        self.mapping[user_addr].staking_time = time.time()
        print(f"You are going to redeem {redeemable} coins! Still can redeem {self.mapping[user_addr].redeemable} coins")
        
        
    def calculate_reward(self,stake_amount):   #view function 
        reward_rate = get_reward_rate() 
        return stake_amount*rate 

def get_reward_rate():
    #this function will belong to the LP not the RewardLocker
    return 1   #1eth staked -- 1 coins

class User:
    def __init__(self):
        self.id = random.randint(1,100)

    
#### Driver code

userA = User()

r = RewardLocker()

r.deposit(userA.id,1)


for i in range(20):
    print(r.calculate_current_redeemable(userA.id))
    if i == 5:
        r.redeem(userA.id)
    if i == 10:
        r.deposit(userA.id,2)
    time.sleep(1)