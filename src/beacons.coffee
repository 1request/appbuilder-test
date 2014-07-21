Client = require "../features/lib/client.js"

uuid = 'B9407F30-F5F8-466E-AFF9-25556B57FE6E';
major = '100'
minor = '200'
zone_enterance = 'Enterance'
zone_info_center = 'Information Center'
notes = 'Information Center at exit East'

row = 'tr[id="' + uuid + '"]'
col = (n) ->
  row + ' > td:nth-child(' + n + ')'
button = (action) ->
  switch action
    when 'new' then 'a[href="/beacons/new"]'
    when 'edit' then row + ' > td:nth-last-child(-n+2) > a'
    when 'delete' then row + ' > td:last-child > a'
    else ''

visitBeaconPage = (client) ->
  client.visitAppBuilder()
  client.login()

  # Visit manage beacons page
  client
    .click 'a[href="/beacons"]'
    .pause 1000
    .assert.containsText 'h2' , 'Beacons'


module.exports =
  'Create beacon' : (browser) ->
    client = new Client browser
    visitBeaconPage client

    # Add beacon
    client
      .click button('new')
      .pause 1000
      .assert.containsText 'h2' , 'Add beacon'
      .setValue 'input[name="uuid"]', uuid
      .setValue 'input[name="major"]', major
      .setValue 'input[name="minor"]', minor
      .setValue 'input[id="s2id_autogen1"]', [zone_enterance, client.Keys.ENTER]
      .setValue 'input[name="notes"]', notes
      .click 'button[type="submit"]' 
      .pause 1000

    # Back to manage beacons page
    client
      .assert.containsText 'h2' , 'Beacons'
      .assert.containsText col(2), major
      .assert.containsText col(3), minor
      .assert.containsText col(4), zone_enterance
      .assert.containsText col(5), notes
      .assert.containsText button('edit'), 'Edit'
      .assert.containsText button('delete'), 'Delete'

    client
      .end()

  , 'Edit beacon' : (browser) ->
    client = new Client browser
    visitBeaconPage client

    # Edit beacon
    client
      .click button('edit')
      .pause 1000
      .assert.containsText 'h2' , 'Edit beacon'
      .setValue 'input[id="s2id_autogen1"]', [zone_info_center, client.Keys.ENTER]
      .click 'button[type="submit"]' 
      .pause 1000

    # Back to manage beacons page
    client
      .assert.containsText 'h2' , 'Beacons'
      .assert.containsText 'h2' , 'Beacons'
      .assert.containsText col(2), major
      .assert.containsText col(3), minor
      .assert.containsText col(4), zone_enterance
      .assert.containsText col(4), zone_info_center
      .assert.containsText col(5), notes
      .assert.containsText button('edit'), 'Edit'
      .assert.containsText button('delete'), 'Delete'

    client
      .end()

  , 'Delete beacon' : (browser) ->
    client = new Client browser
    visitBeaconPage client

    # Delete beacon
    client
      .click button('delete')
      .pause 1000

    # Back to manage beacons page
    client
      .assert.containsText 'h2' , 'Beacons'
      .assert.elementNotPresent row

    client
      .end()
