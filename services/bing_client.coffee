request = require("request")
lodash = require("lodash")

config = require('../config')

bingClient = {
  request: request
  lodash: lodash
  username: config.keys.bing.username
  password: config.keys.bing.password

  searchForPhoto: (searchQuery, callback) ->
    request.get 'https://api.datamarket.azure.com/Bing/Search/v1/Image', {
      qs:
        "Query": "'#{searchQuery}'"
        "$format": "json"
        "ImageFilters": "'Size:Large+Style:Photo'"
        "Adult": "'Strict'"
      auth:
        username: @username
        password: @password
    }, (err, response, body) =>
      if !err && response.statusCode >= 200 && response.statusCode < 400
        try
          rawResults = JSON.parse(body).d.results
          results = @lodash.first(rawResults, 5)
          rawPhoto = @lodash.sample(results)

          if rawPhoto
            photo =
              url: rawPhoto.MediaUrl
              pageUrl: rawPhoto.SourceUrl
              author: null

            callback null, photo
          else
            callback { whoFailed: "Bing", whatFailed: "rawPhotoIsNull"}
      else
        callback err, response, body

}

module.exports = bingClient
