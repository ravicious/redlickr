express = require('express')
path = require('path')
jade = require('jade')
bodyParser = require('body-parser')
logfmt = require('logfmt')

app = express()
app.use bodyParser()
app.use express.static(__dirname + '/public')
app.set 'view engine', 'jade'
app.set 'views', path.join(__dirname, 'views')

app.use(logfmt.requestLogger())

redlickrClient = require('./services/redlickr_client.coffee')

app.get '/', (req, res) ->
  res.render 'index'

app.get '/art/random', (req, res) ->
  redlickrClient.randomArt (err, art) ->
    if err
      console.log err, art
      res.json 422, err
    else
      console.log JSON.stringify(art)
      res.json art

port = Number(process.env.PORT || 3000)
server = app.listen port, ->
  console.log '%d environment', process.env.NODE_ENV
  console.log 'Listening on port %d', server.address().port
