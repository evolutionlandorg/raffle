## Raffle

Gold Rush Event.  

Users can submit the land of the EVO, and any number of RINGs as reserves to participate in the lottery of the New World. The more RINGs, the higher the probability of being selected. 

### API

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
  "RAFFLE_PROXY": "0x005d5D8D31078e3E3cdaE300BfDc11F6327a189E"
}
```

#### Tron shasta
```json
{
  "Raffle": {
  	"base58": "TEdKu2pfHC82yjhACMT45jAW6MXZN7DEMd",
	"hex": "41331610f5b595ea4265fbc4d20cd6ab67e851c6f1"
  } 
}
```
