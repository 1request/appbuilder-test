var Client = require('./lib/client.js')

var appName = 'MyApp';

module.exports = {
  'Create App' : function(browser) {
    client = new Client(browser);
    client.visitAppBuilder();
    client.login();

    // Create App
    client
      .click('li[id="apps-dropdown-list"] > *:first-child')
      .waitForElementVisible('a[href="/apps/new"]', 1000)
      .click('a[href="/apps/new"]')
      .waitForElementVisible('input[name="name"]', 1000)
      .setValue('input[name="name"]', appName)
      .waitForElementVisible('button[type="submit"]', 1000)
      .click('button[type="submit"]')
      .pause(1000);

    // Validate
    client
      .assert.urlEquals('http://localhost:3000/apps/edit')
      .assert.containsText('div[class="alert alert-success"]', 'successfully created MyApp')
      .assert.containsText('li[id="apps-dropdown-list"] > *:first-child', appName);

    // Set appKey
    client
      .click('li[id="apps-dropdown-list"] > *:first-child')
      .getText('span[id="currentAppKey"]', function(result) {
        this.globals.appKey = result.value;
      })
      .pause(1000)
      .end();    
  },
  'View newly created App' : function(browser) {
    client = new Client(browser);
    client.visitAppBuilder();
    client.login();

    var appKey = client.appKey

    // Switch to newly created app
    client
      .click('li[id="apps-dropdown-list"] > *:first-child')
      .click('a[id="app-' + appKey + '"]')
      .pause(1000)

    // Validate App edit page
    client
      .assert.containsText('h2', appName)
      .assert.containsText('h3', 'App key: ' + appKey)
      .assert.visible('iframe[src="/app/' + appKey + '/demo-user-' + appKey + '"]')
      .pause(1000)
      .end();
  },
  'Edit App' : function(browser) {
    client = new Client(browser);
    client.visitAppBuilder();
    client.login();

    var appKey = client.appKey;
    var newAppName = 'AppMe';

    // Switch to newly created app
    client
      .click('li[id="apps-dropdown-list"] > *:first-child')
      .click('a[id="app-' + appKey + '"]')
      .pause(1000)

    // Open mobile app view in another window
    client
      .click('a[id="viewMobile"]');

    // Switch back to web view and edit App
    client
      .windowHandles(function(result){
        var webWindow = result.value[0];
        this.switchWindow(webWindow);
      })
      .clearValue('input[name="name"]')
      .setValue('input[name="name"]', newAppName)
      .pause(1000);

    // Switch back and validate mobile app view
    client
      .assert.containsText('li[id="apps-dropdown-list"] > *:first-child', newAppName)
      .windowHandles(function(result){
        var mobiWindow = result.value[1];
        this.switchWindow(mobiWindow);
      })
      .assert.containsText('h1[class="brandname"]', newAppName)
      .closeWindow()
      .end();
  }
}