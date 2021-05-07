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
  "base58": "TXJnfPHxynNqcXjyebprA14dpLGS87h9eU",
	"hex": "41ea0ea4b2a3d745597153f67d438b58e729189b11"
}

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let raffle = await tronWeb.contract().at(Raffle.hex);
  let eventId=2
  let toLandId=4
  let startBlock=1618808952
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
