## Raffle

Gold Rush Event.  

Users can stake the land of the EVO, and any number of RINGs as reserves to participate in the lottery of the New World. The more RINGs, the higher the probability of being selected. 

### API

#### `check(uint256)`
Return if the `_landId` is valid

#### `join(uint256,uint256,address)`
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

