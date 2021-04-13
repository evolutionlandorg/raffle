var TronWeb = require('tronweb')
var Raffle = require("../build/contracts/Raffle.json")

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

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let contract_instance = await tronWeb.contract().new({
    abi:Raffle.abi,
    bytecode:Raffle.bytecode,
    feeLimit:1000000000,
    callValue:0,
    userFeePercentage:1,
    originEnergyLimit:10000000,
    parameters:[SettingsRegistry.hex, Supervisor.hex,2]
  });
  console.log(contract_instance.address);
  console.log("finished");
};

app();
