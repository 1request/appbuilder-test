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

    message = 'It\'s time for lunch!'
    url = 'http://www.openrice.com'

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
      .click button('in/out')
      .click button('submit')
      .pause 3000

    # Validate after creating notification
    client
      .assert.containsText col(2), message
      .assert.containsText col(3), 'Open web page'
      .assert.containsText col(4), url
      .assert.containsText button('delete'), 'Delete Notification'
      .end()

  'Create instant notification and open image' : (browser) ->
    client = new Client browser
    login()
    switchAppToKodw()
    visitInstantNotificationPage()

    message = '紅米1S智能電話香港版 + 1年原廠保養服務'
    filename = 'redmi1s.jpg'
    file = process.cwd() + '/data/' + filename

    # Add instant notification
    client
      .click button('new')
      .pause 1000
      .assert.containsText 'h2' , 'Instant Notifications'
    
    # Select action: Open web page
    client
      .click 'select[id="action"]'
      .click 'option[value="image"]'
      .pause 1000
      .assert.elementPresent 'input[name="message"]'
      .assert.elementPresent 'input[type=file]'

    # Input notification detail
    client
      .setValue 'input[type=file]', file
      .setValue 'input[name="message"]', message
      .pause 5000
      .assert.elementPresent 'img[alt="' + filename + '"]'
      .assert.containsText 'div[class="lock-screen-app-title"]', kodw
      .assert.containsText 'div[class="lock-screen-app-text"]', message
      .click button('submit')
      .pause 3000

    # Validate after creating notification
    client
      .assert.containsText col(2), message
      .assert.containsText col(3), 'Open image'
      .assert.elementPresent col(4) + ' > img'
      .assert.containsText button('delete'), 'Delete Notification'
      .end()

  'Create instant notification and open video' : (browser) ->
    client = new Client browser
    login()
    switchAppToKodw()
    visitInstantNotificationPage()

    message = 'Mobile Innovation: O2O User Experience'
    url = 'http://youtu.be/vdd0O2Wp364'

    # Add instant notification
    client
      .click button('new')
      .pause 1000
      .assert.containsText 'h2' , 'Instant Notifications'
    
    # Select action: Open web page
    client
      .click 'select[id="action"]'
      .click 'option[value="video"]'
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
      .pause 10000

    # Validate after creating notification
    client
      .assert.containsText col(2), message
      .assert.containsText col(3), 'Open video'
      .assert.containsText col(4), url
      .assert.containsText button('delete'), 'Delete Notification'
     .end()

  'Show preview error page when opening an URL with CORS policy problem' : (browser) ->
    client = new Client browser
    login()
    switchAppToKodw()
    visitInstantNotificationPage()

    # Goto add instant notification page
    client
      .click button('new')
      .pause 1000

    # Select action: Open web page
    client
      .click 'select[id="action"]'
      .click 'option[value="url"]'
      .pause 1000
      .assert.elementPresent 'input[name="message"]'
      .assert.elementPresent 'input[name="url"]'

    # Input url with CORS policy problem
    client
      .setValue 'input[name="url"]', 'http://www.google.com'
      .click button('in/out')
      .pause 10000
      .assert.visible 'iframe[src="/cors"]'
      .click button('in/out')
      .end()
