React = require('react')
request = require('browser-request')
Spinner = require('./spinner')
HistoryList = require('./history_list.coffee')

R = React.DOM

Redlickr = React.createClass
  displayName: "redlickr"

  getInitialState: ->
    art: null
    loadingInProgress: false
    showHistory: false
    historyItems: []

  getRandomArt: (callback) ->
    request.get '/art/random', (err, response, body) ->
      if !err && response.statusCode >= 200 && response.statusCode < 400
        callback null, JSON.parse(body)
      else
        # if there's no error, but response wasn't successfull
        unless err
          err = { statusCode: response.statusCode, body: body}
        callback err, response

  onRandomClick: (e) ->
    e?.preventDefault()
    if @props.googleTracker
      @props.googleTracker('send', 'event', 'randomClick')

    @setState loadingInProgress: true

    @getRandomArt (err, result) =>
      if err
        errorBody = err.body && JSON.parse(err.body)
        if errorBody && errorBody.whoFailed == "Bing" && errorBody.whatFailed == "rawPhotoIsNull"
          console.log "Error while fetching photos from Bing, retrying…"
          @onRandomClick()
        else
          console.log err, result
          @setState loadingInProgress: false
          alert "Wow, something went wrong, try again"
      else
        # Array.push and Array.unshift return the size of the new array :c
        @state.historyItems.unshift(result)
        @setState
          art: result
          historyItems: @state.historyItems
          loadingInProgress: false

  onRandomClickProxy: (e) ->
    e?.preventDefault()
    @onRandomClick() if not @state.loadingInProgress

  onHistoryItemClick: (item) ->
    @setState
      art: item

  onToggleHistoryClick: (e) ->
    e?.preventDefault()
    @setState
      showHistory: !@state.showHistory

  onKeyDown: (e) ->
    # 13 - enter, 32 - space
    @onRandomClickProxy(e) if e.keyCode in [13, 32]

  componentDidMount: ->
    document.onkeydown = @onKeyDown

  showSpinner: ->
    R.div {className: "spinnerWrapper"}, Spinner()

  render: ->
    # kind wonky, but if we don't check for the state of body backgroundImage,
    # it gets repainted every time
    backgroundElement = document.getElementsByClassName('photoBox')[0]
    if @state.art && backgroundElement.style.backgroundImage != "url(#{@state.art.url})"
      # remove image first, so if the new one doesn't load,
      # we aren't stuck with the old one
      backgroundElement.style.backgroundImage = ""
      backgroundElement.style.backgroundImage = "url(#{@state.art.url})"

    R.div {className: 'redlickr'},
      R.div {className: 'photoBox', onClick: @onRandomClickProxy}
      @showSpinner() if @state.loadingInProgress
      R.div {className: 'controls'},
        R.div {className: 'buttons'},
          R.button {className: 'toggleHistory', onClick: @onToggleHistoryClick}, "Toggle history"
          R.button {className: 'randomizer', onClick: @onRandomClick, disabled: @state.loadingInProgress}, "Random art"
        # R.div {className: 'clearfix'}
        HistoryList
          historyItems: @state.historyItems
          onHistoryItemClick: @onHistoryItemClick
          visible: @state.showHistory
          activeItemUuid: @state.art?.uuid
        R.h1 {className: 'title', onClick: @onRandomClickProxy}, @state.art?.title || "Tap me, space or a button, buddy"

module.exports = Redlickr
