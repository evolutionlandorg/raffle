var Raffle = artifacts.require("Raffle")
var RaffleProxy = artifacts.require("RaffleProxy")
var TronWeb = require('tronweb')

const SettingsRegistry = {
  base58: "TV7XzfAcDrcpFmRkgCh2gg8wf15Cz9764W",
  hex: "41d1fd927d8bf55bff2dfb8248047bc9881e710cc7"
}

const Supervisor = {
  base58: "TA2YGCFuifxkJrkRrnKbugQF5ZVkJzkk4p",
  hex: "4100A1537D251A6A4C4EFFAB76948899061FEA47B9"
}

const tronWeb = new TronWeb({
  fullHost: 'https://api.shasta.trongrid.io',
  headers: { "TRON-PRO-API-KEY": process.env.API_KEY },
  privateKey: process.env.PRIVATE_KEY_SHASTA
})

let params = {
  feeLimit:1000000000,
  callValue: 1000,
  shouldPollResponse:true
}

let abi = [
    {
      "constant": false,
      "inputs": [
        {
          "name": "_registry",
          "type": "address"
        },
        {
          "name": "_supervisor",
          "type": "address"
        },
        {
          "name": "_fromLandId",
          "type": "uint256"
        }
      ],
      "name": "initializeContract",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    }
]

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
      await asyncDeploy(deployer, network, accounts);
  });
};

async function asyncDeploy(deployer, network, accounts) {
  tronWeb.setDefaultBlock('latest');
  await deployer.deploy(Raffle)
  await deployer.deploy(RaffleProxy)
  let raffleProxy = await RaffleProxy.deployed()
  await raffleProxy.upgradeTo(Raffle.address)
  console.log("upgrade succeed")
  let proxy = await tronWeb.contract(abi, RaffleProxy.address)
  await proxy.initializeContract(SettingsRegistry.hex, Supervisor.hex, 2).send(params)
  console.log("initialize succeed")
  console.log("finished!")
}

