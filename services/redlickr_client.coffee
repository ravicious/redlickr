redtubeClient = require('./redtube_client.coffee')
flickrClient = require('./flickr_client.coffee')
bingClient = require('./bing_client.coffee')
wordFilter = require('./word_filter.coffee')
pornWords = require('./porn_words.coffee')
lodash = require('lodash')
uuidGenerator = require('node-uuid')

redlickrClient =
  redtubeClient: redtubeClient
  photoSearchClient: bingClient
  lodash: lodash
  wordFilter: wordFilter
  pornWords: pornWords
  uuidGenerator: uuidGenerator

  randomArt: (callback) ->
    @redtubeClient.getRandomVideo (err, video) =>
      if err
        if err.whoFailed == "Redtube" && err.whatFailed == "videosLengthIsZero"
          console.log "Redtube: videos size is zero, retrying…"
          @randomArt callback
        else
          callback err
      else
        title = video.title
        filteredTitle = @wordFilter.filter(title, @pornWords)

        @photoSearchClient.searchForPhoto filteredTitle, (err, photo) =>
          if err
            callback err
          else
            uuid = uuidGenerator.v1()
            art = @lodash.assign(photo, { title: title, filteredTitle: filteredTitle, uuid: uuid })
            callback null, art

module.exports = redlickrClient
