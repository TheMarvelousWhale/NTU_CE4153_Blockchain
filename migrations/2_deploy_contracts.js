

module.exports = function(deployer) {
  deployer.deploy(artifacts.require("KleeRewardV2"));
  deployer.deploy(artifacts.require("KleeCoinV2"));
  deployer.deploy(artifacts.require("YM1"));
  deployer.deploy(artifacts.require("YM2"));
  deployer.deploy(artifacts.require("KleeTokenV6"));
  deployer.deploy(artifacts.require("KleeMineV1"));
};