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
  "RAFFLE_PROXY": "0x5e6E812d9A7D35C344C7725835D85c8F977157B7"
}
```

#### Tron shasta
```json
{
  "Raffle": {
  	"base58": "TH59L9YPZXk8vCq8rA1mfQTGEM6Y6DjNZ5",
	"hex": "414de84fdcc7b32452f6fcecf2021458e41aceb0f0"
  } 
}
```

#### Mainnet
```json
{
  "RAFFLE_PROXY": "0x56746a8099a7e6D962802A23e01FeDdc1282cDAe"
}
```

#### Tron 
```json
{
  "Raffle": {
  	"base58": "TAkDMgTFMPsRPiy43ZoFRpGjSPNTpqZCeg",
	"hex": "41088303DC5304E273A5A838B4BB9B9645D737EE0E"
  } 
}
```
