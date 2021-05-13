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

#### Tron shasta

```json
{
  "Raffle": {
  	"base58": "TDoKYLbAmC9CLiD2D6Y6woaNTuPpB8cZzP",
	"hex": "412a01cd606796d1b75aab86b52cab92d21060d0cc"
  }, 
  "RaffleProxy": {
  	"base58": "THcjnVV6R6ipwkBUy88prmgVsac55UWYje",
	"hex": "4153e1f7bb25bacfe7fec16e8d2dcedcaa99d9571c"
  } 
}
```
