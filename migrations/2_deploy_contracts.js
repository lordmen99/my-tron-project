 var SendMessages = artifacts.require("./SendMessages.sol");

module.exports = function(deployer) {
   deployer.deploy(SendMessages);
};
