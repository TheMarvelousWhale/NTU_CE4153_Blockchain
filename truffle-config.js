module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id,
      from: "0x6941C528CB9395301711c8D169e3B03eAd942015"
    },
    develop: {
      port: 8545
    }
  },
  compilers: {
    solc: {
      version: "0.8.0"
    }
  }
};
