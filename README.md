## Raffle

Gold Rush Event.  

Users can stake the land of the EVO, and any number of RINGs as reserves to participate in the lottery of the New World. The more RINGs, the higher the probability of being selected. 

### API

#### `check(uint256 _landId)`
Return if the `_landId` is valid

#### `join(uint256 _landId, uint256 _amount, address _subAddr)`
Submit the land and RINGs as reserves to join the event. 

#### `changeAmount(uint256 _landId,  uint256 _amount)`
Change the ring amount which joined the event.

#### `changeSubAddr(uint256 _landId, address _subAddr)`
Change the dvm address which use to receive new land.

#### `exit(uint256 _landId)`
Exit the event

#### `draw(uint256 _landId, bool _won, bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s)`
Redeem prize after lottery

### [Lottery rule](./Lottery-en.md)

