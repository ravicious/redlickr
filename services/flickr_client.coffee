request = require("request")

class FlickrClient
  constructor: (@request) ->

  searchForPhoto: (searchQuery, callback) ->
    photo =
      url: "https://i.imgur.com/OlavqbM.jpg"
      pageUrl: "https://imgur.com/OlavqbM"
      author: "eloelo"

    callback null, photo

module.exports = new FlickrClient(request)
