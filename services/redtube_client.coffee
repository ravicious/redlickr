request = require('request')
lodash = require('lodash')
TitleValidator = require('./title_validator.coffee')
wordFilter = require('./word_filter.coffee')
pornWords = require('./porn_words.coffee')
async = require('async')

redtubeClient =
  request: request
  lodash: lodash
  wordFilter: wordFilter
  pornWords: pornWords
  async: async

  period: ["weekly", "monthly", "alltime"]
  ordering: ["newest", "mostviewed", "rating"]

  randomPage: ->
    maxPage = 2000
    minPage = 0
    Math.floor(Math.random() * (maxPage - minPage + 1)) + minPage

  getRandomVideosPage: (callback) ->
    url = "http://api.redtube.com/?data=redtube.Videos.searchVideos"
    querystring =
      output: 'json'
      ordering: @lodash.sample(@ordering)
      period: @lodash.sample(@period)
      page: @randomPage()

    request.get url, {
      qs: querystring
    }, (err, response, body) ->
      console.log 'redtube request', response.statusCode, new Date()
      if !err && response.statusCode >= 200 && response.statusCode < 400
        callback err, JSON.parse(body).videos
      else
        if response && response.statusCode == 503
          callback { whoFailed: "Redtube", whatFailed: "serviceUnavailable" }, response
        else
          callback err, response

  getFilteredVideos: (callback) ->
    @getRandomVideosPage (err, videos) =>
      if err
        if err.whoFailed == "Redtube" && err.whatFailed == "serviceUnavailable"
          callback null, []
        else
          callback err
      else
        @filterVideosArray videos, (err, filteredVideos) ->
          callback err, filteredVideos

  getVideosInParallel: (requestCount, callback) ->
    functionsArray = []
    for [1..requestCount]
      functionsArray.push @getFilteredVideos.bind(redtubeClient)

    @async.parallel functionsArray, (err, resultArray) ->
      if err
        callback err
      else
        videos = [].concat.apply([], resultArray)
        callback null, videos

  getRandomVideo: (callback) ->
    @getVideosInParallel 3, (err, videos) =>
      if err
        callback err
      else
        if videos.length == 0
          callback { whoFailed: "Redtube", whatFailed: "videosLengthIsZero" }
        else
          randomVideoWrapper = @lodash.sample(videos)
          callback null, randomVideoWrapper.video

  filterVideosArray: (videos, callback) ->
    filteredVideos = @lodash.filter videos, (videoWrapper) =>
      video = videoWrapper.video
      if video
        titleValidator = new TitleValidator(video.title, @lodash, @wordFilter, @pornWords)
        titleValidator.isValid()
    callback null, filteredVideos

module.exports = redtubeClient
