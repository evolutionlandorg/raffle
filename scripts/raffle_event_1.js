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
  "base58": "TYckgaNb2byLvuwqY6JaCgpbDECcKBbo7H",
	"hex": "41F86C9AA48102D61943789A07E0C97EB8D923436B"
}

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let raffle = await tronWeb.contract().at(Raffle.hex);
  let eventId=1
  let toLandId=4
  let startBlock=1624339800
  let endBlock=1624354200
  let finalBlock=1624354800
  let expireBlock=1624350600
  let ret = await raffle.setEvent(eventId, toLandId, startBlock, endBlock, finalBlock, expireBlock).send({
      feeLimit:1e8,
      callValue:0,
      shouldPollResponse:true
  })
  console.log(ret)
  console.log("finished");
};

app();
