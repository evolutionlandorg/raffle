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
 	"base58": "TVshkqR34hD6pdveeBEfEybCpTYCUwru56",
	"hex": "41da5805eee3a47c43792f319ea8d66b88c3f20d5a"
}

const abi = [
    {
      "constant": false,
      "inputs": [],
      "name": "stop",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "events",
      "outputs": [
        {
          "name": "startTime",
          "type": "uint256"
        },
        {
          "name": "endTime",
          "type": "uint256"
        },
        {
          "name": "finalTime",
          "type": "uint256"
        },
        {
          "name": "expireTime",
          "type": "uint256"
        },
        {
          "name": "toLandId",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "fromLandId",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "owner_",
          "type": "address"
        }
      ],
      "name": "setOwner",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "CONTRACT_RING_ERC20_TOKEN",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "supervisor",
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
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "lands",
      "outputs": [
        {
          "name": "user",
          "type": "address"
        },
        {
          "name": "balance",
          "type": "uint256"
        },
        {
          "name": "subAddr",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "stopped",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "authority_",
          "type": "address"
        }
      ],
      "name": "setAuthority",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "registry",
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
    {
      "constant": true,
      "inputs": [],
      "name": "CONTRACT_OBJECT_OWNERSHIP",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [],
      "name": "start",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "CONTRACT_REVENUE_POOL",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "authority",
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
    {
      "constant": true,
      "inputs": [],
      "name": "CONTRACT_LAND_RESOURCE",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "MINI_AMOUNT",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "amount",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "subAddr",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "fromLandId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "toLandId",
          "type": "uint256"
        }
      ],
      "name": "Join",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "ChangeAmount",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "subAddr",
          "type": "address"
        }
      ],
      "name": "ChangeSubAddr",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "Exit",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "amount",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "subAddr",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "fromLandId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "toLandId",
          "type": "uint256"
        }
      ],
      "name": "Win",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "name": "landId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "amount",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "subAddr",
          "type": "address"
        }
      ],
      "name": "Lose",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "eventId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "start",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "end",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "finalTime",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "expire",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "toLandId",
          "type": "uint256"
        }
      ],
      "name": "SetEvent",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "authority",
          "type": "address"
        }
      ],
      "name": "LogSetAuthority",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "LogSetOwner",
      "type": "event"
    },
    {
      "anonymous": true,
      "inputs": [
        {
          "indexed": true,
          "name": "sig",
          "type": "bytes4"
        },
        {
          "indexed": true,
          "name": "guy",
          "type": "address"
        },
        {
          "indexed": true,
          "name": "foo",
          "type": "bytes32"
        },
        {
          "indexed": true,
          "name": "bar",
          "type": "bytes32"
        },
        {
          "indexed": false,
          "name": "wad",
          "type": "uint256"
        },
        {
          "indexed": false,
          "name": "fax",
          "type": "bytes"
        }
      ],
      "name": "LogNote",
      "type": "event"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "i",
          "type": "uint256"
        }
      ],
      "name": "getEvent",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
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
    },
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
      "constant": false,
      "inputs": [
        {
          "name": "_eventId",
          "type": "uint256"
        },
        {
          "name": "_landIds",
          "type": "uint256[]"
        },
        {
          "name": "_amounts",
          "type": "uint256[]"
        },
        {
          "name": "_subAddrs",
          "type": "address[]"
        }
      ],
      "name": "joins",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
        }
      ],
      "name": "changeAmount",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
          "name": "_subAddr",
          "type": "address"
        }
      ],
      "name": "changeSubAddr",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
      "name": "change",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
        }
      ],
      "name": "exit",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
          "name": "_won",
          "type": "bool"
        },
        {
          "name": "_hashmessage",
          "type": "bytes32"
        },
        {
          "name": "_v",
          "type": "uint8"
        },
        {
          "name": "_r",
          "type": "bytes32"
        },
        {
          "name": "_s",
          "type": "bytes32"
        }
      ],
      "name": "draw",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_newSupervisor",
          "type": "address"
        }
      ],
      "name": "setSupervisor",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
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
  // let toLandId=3
  // let startBlock=1620272023
  // let endBlock=1620587755
  // let finalBlock=1620674155
  // let expireBlock=1628622955
  // let ret = await raffle.setEvent(eventId, toLandId, startBlock, endBlock, finalBlock, expireBlock).send({
  //     feeLimit:1e8,
  //     callValue:0,
  //     shouldPollResponse:true
  // })
  // console.log(ret)
  // console.log(await raffle.getEvent(1).call())
  console.log(await raffle.CONTRACT_REVENUE_POOL().call())
  console.log("finished");
};

app();
