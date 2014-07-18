module.exports = function(_client) {
  client = _client;

  client.appKey = _client.globals.appKey;

  client.visitAppBuilder = function() {
    _client 
      .url('http://localhost:3000')
      .pause(1000);
      //.waitForElementVisible('body', 1000);
  }

  client.login = function() {
    _client
      .click('li[id="login-dropdown-list"] > *:first-child')
      .setValue('input[id="login-username-or-email"]', 'joe')
      .setValue('input[id="login-password"]', '1')
      .click('button[id="login-buttons-password"]')
      .pause(1000);
  }

  client.logout = function() {
    _client
      .click('li[id="login-dropdown-list"] > *:first-child')
      .click('button[id="login-buttons-logout"]')
      .pause(1000);
  }

  return client;
};
