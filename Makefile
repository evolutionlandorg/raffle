all    :; source .env.local && dapp --use solc:0.6.7 build
clean  :; dapp clean
test   :; dapp test
deploy :; dapp create Raffle
