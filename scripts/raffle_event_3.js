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
  "base58": "TH59L9YPZXk8vCq8rA1mfQTGEM6Y6DjNZ5",
	"hex": "414de84fdcc7b32452f6fcecf2021458e41aceb0f0"
}

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let raffle = await tronWeb.contract().at(Raffle.hex);
  let eventId=3
  let toLandId=3
  let startTime=1648008256
  let endTime=1648022400
  let finalTime=1648023000
  let expireTime=1648030200
  let ret = await raffle.setEvent(eventId, toLandId, startTime, endTime, finalTime, expireTime).send({
      feeLimit:1e8,
      callValue:0,
      shouldPollResponse:true
  })
  console.log(ret)
  console.log("finished");
};

app();
