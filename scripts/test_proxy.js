var TronWeb = require('tronweb')

const tronWeb = new TronWeb({
    fullHost: 'https://api.shasta.trongrid.io',
    headers: { "TRON-PRO-API-KEY": process.env.API_KEY },
    privateKey: process.env.PRIVATE_KEY_SHASTA
})

const Registry = {
  base58: "TZ8bdeqw7PdTsHbs3RX2uetQ9RwYmGFdeU",
  hex: "41FE11872D7054CF47F88AC380DFAB102B8CCFF06D"
}

const LogicOne = {
  base58: "TP4duEefDx7tiNCG9YPdYWcQ3VXjGF3Dx5",
  hex: "418FA0800955BB6282549C3AA0C66E38806623AD28"
}

const LogicTwo = {
  "base58": "TC7M7RUSspENggkj32mS2PmgrPbWzGrAfW",
	"hex": "41177A59528404FCEF3E72AD69F4838C4208948FD8"
}

let abi = [{"constant":true,"inputs":[],"name":"val","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_val","type":"uint256"}],"name":"setVal","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"}];  

const app = async () => {
  tronWeb.setDefaultBlock('latest');
  let registry = await tronWeb.contract(abi, Registry.hex);
  console.log(await registry.val().call())
  try {
    let ret = await registry.setVal(2).send({
        feeLimit:1e8,
        callValue:0,
        shouldPollResponse:true
    })
    console.log(ret)
  } catch (err) {
    console.log(err)
  }
  console.log(await registry.val().call())
  console.log("finished");
};

app();
