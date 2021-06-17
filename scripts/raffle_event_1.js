var TronWeb = require('tronweb')

const tronWeb = new TronWeb({
    fullHost: 'https://api.shasta.trongrid.io',
    headers: { "TRON-PRO-API-KEY": process.env.API_KEY },
    privateKey: process.env.PRIVATE_KEY_SHASTA
})

const SettingsRegistry = {
  base58: "TV7XzfAcDrcpFmRkgCh2gg8wf15Cz9764W",
  hex: "41d1fd927d8bf55bff2dfb8248047bc9881e710cc7"
}

const Supervisor = {
  base58: "TA2YGCFuifxkJrkRrnKbugQF5ZVkJzkk4p",
  hex: "4100A1537D251A6A4C4EFFAB76948899061FEA47B9"
}

const Raffle = {
 	"base58": "TBccQWiATG3xH89J9Brqp8HiyGeZDDPtgg",
	"hex": "41120b0da92df26b7cd5de70e24ed47fffde916c1c"
}

const abi = [
    {
      "constant": false,
      "inputs": [
        {
          "name": "_eventId",
          "type": "uint256"
        },
        {
          "name": "_toLandId",
          "type": "uint256"
        },
        {
          "name": "_start",
          "type": "uint256"
        },
        {
          "name": "_end",
          "type": "uint256"
        },
        {
          "name": "_final",
          "type": "uint256"
        },
        {
          "name": "_expire",
          "type": "uint256"
        }
      ],
      "name": "setEvent",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    }
]

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let raffle = await tronWeb.contract(abi, Raffle.hex);
  let eventId=1
  let toLandId=3
  let startBlock=1620272023
  let endBlock=1620587755
  let finalBlock=1620674155
  let expireBlock=1628622955
  let ret = await raffle.setEvent(eventId, toLandId, startBlock, endBlock, finalBlock, expireBlock).send({
      feeLimit:1e8,
      callValue:0,
      shouldPollResponse:true
  })
  console.log(ret)
  console.log("finished");
};

app();
