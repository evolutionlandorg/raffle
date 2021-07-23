var TronWeb = require('tronweb')

const tronWeb = new TronWeb({
    fullHost: 'https://api.shasta.trongrid.io',
    headers: { "TRON-PRO-API-KEY": process.env.API_KEY },
    privateKey: process.env.PRIVATE_KEY_SHASTA
})

const Raffle = {
 	"base58": "TX67FoajBX2X5x1qztS4fvwmwwVWhSFwPi",
	"hex": "41e7a8c1c181e6ab2d4e472ec429749ebfb42af970"
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
          "name": "_landId",
          "type": "uint256"
        },
        {
          "name": "_amount",
          "type": "uint256"
        },
        {
          "name": "_subAddr",
          "type": "address"
        }
      ],
      "name": "join",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
]

let params = {
  feeLimit:1000000000,
  callValue: 1000,
  shouldPollResponse:true
}
const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let land = "0x2a02000102000101000000000000000200000000000000000000000000000133"
  let amount = "2000000000000000000";
  let raffle = await tronWeb.contract(abi, Raffle.hex);
  let ret = await raffle.join(1, land, amount, Raffle.hex).send(params)
  console.log(ret)
  console.log("finished");
};

app();
