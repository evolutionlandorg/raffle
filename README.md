## Raffle

Gold Rush Event.  

Users can submit the land of the EVO, and any number of RINGs as reserves to participate in the lottery of the New World. The more RINGs, the higher the probability of being selected. 

### API

#### `check(uint256)`
Return if the `_landId` is valid

#### `join(uint256,uint256,address,uint256)`
Submit the land and RINGs as reserves to join the event. 

#### `changeAmount(uint256,uint256)`
Change the ring amount which joined the event.

#### `changeSubAddr(uint256,address)`
Change the dvm address which use to receive new land.

#### `exit(uint256)`
Exit the event

#### `draw(uint256,bool,bytes32,uint8,bytes32,bytes32)`
Redeem prize after lottery

### [Lottery rule](./Lottery-en.md)

### Addresses

#### Ropsten
```json
{
  "RAFFLE_PROXY": "0x34aA7900c9ec8992c51D8229EC22b488561a191F"
}
```

#### Tron shasta
```json
{
  "Raffle": {
  	"base58": "TXA3qBwvx4VaeJbLcKNwHvEKewNb8sQCgN",
	"hex": "41e8678fea8bbce8577ce7ea430aa0da7f38ad9b8c"
  } 
}
```
