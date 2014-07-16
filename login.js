var Client = require("./client.js");

module.exports = {
  'Login' : function (cli) {
    client = new Client(cli);
    client.visitAppBuilder();
    client.login();

    client
      .assert.containsText('li[id="login-dropdown-list"] > *:first-child', 'joe')
      .end();
  },
  'Logout' : function (cli) {
    client = new Client(cli);
    client.visitAppBuilder();
    client.login();
    
    client.logout();
    client
      .assert.containsText('li[id="login-dropdown-list"] > *:first-child', 'sign in / up')
      .end();
  }
};
