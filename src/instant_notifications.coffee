Notification  = require '../app/models/notification'

Client = require "../features/lib/client.js"
client = undefined
kodw = 'KODW'

switchAppToKodw = ->
  client
    .click('li[id="apps-dropdown-list"] > *:first-child')
    .click('a[id="app-jdFYjuCqWyCdrywPT"]')
    .pause(1000)

login = ->
  client.visitAppBuilder()
  client.login()

visitInstantNotificationPage = ->
  # Visit manage beacons page
  client
    .click 'a[id="notification-dropdown"]'
    .pause 1000
    .click 'a[href="/apps/instantNotifications"]'
    .pause 1000
    .assert.containsText 'h2' , 'Instant Notifications'

row = 
  'table[class="table table-striped"] > tbody > tr:first-child'

col = (n) ->
  row + ' > td:nth-child(' + n + ')'

button = (action) ->
  switch action
    when 'new' then 'a[href="/notifications/new"]'
    when 'edit' then row + ' > td:nth-last-child(-n+2) > a'
    when 'delete' then row + ' > td:last-child > a'
    when 'in/out' then 'a[data-original-title="In/Out"]'
    when 'submit' then 'button[type="submit"]'
    else ''

module.exports =
  'Create instant notification' : (browser) ->
    client = new Client browser
    login()
    switchAppToKodw()
    visitInstantNotificationPage()

    message = 'Welcome to KODW'

    # Add instant notification
    client
      .click button('new')
      .pause 1000
      .assert.containsText 'h2' , 'Instant Notifications'
    
    # Select action: Open web page
    client
      .click 'select[id="action"]'
      .click 'option[value="message"]'
      .pause 1000
      .assert.elementPresent 'input[name="message"]'

    # Input notification detail
    client
      .setValue 'input[name="message"]', message
      .assert.containsText 'div[class="lock-screen-app-title"]', kodw
      .assert.containsText 'div[class="lock-screen-app-text"]', message
      .click button('submit')
      .pause 1000

    # Validate after creating notification
    client
      .assert.containsText col(2), message
      .assert.containsText col(3), 'Message only'
      .assert.containsText button('delete'), 'Delete Notification'
      .end()

  'Create instant notification and open URL' : (browser) ->
    client = new Client browser
    login()
    switchAppToKodw()
    visitInstantNotificationPage()

    message = 'It\'s time to Google!'
    url = 'http://www.google.com'

    # Add instant notification
    client
      .click button('new')
      .pause 1000
      .assert.containsText 'h2' , 'Instant Notifications'
    
    # Select action: Open web page
    client
      .click 'select[id="action"]'
      .click 'option[value="url"]'
      .pause 1000
      .assert.elementPresent 'input[name="message"]'
      .assert.elementPresent 'input[name="url"]'

    # Input notification detail
    client
      .setValue 'input[name="message"]', message
      .setValue 'input[name="url"]', url
      .assert.containsText 'div[class="lock-screen-app-title"]', kodw
      .assert.containsText 'div[class="lock-screen-app-text"]', message
      .click button('in/out')
      .assert.visible 'iframe[src="' + url + '"]'
      .click button('submit')
      .pause 1000

    # Validate after creating notification
    client
      .assert.containsText col(2), message
      .assert.containsText col(3), 'Open web page'
      .assert.containsText col(4), url
      .assert.containsText button('delete'), 'Delete Notification'
      .end()
