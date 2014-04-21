React = require('react')
Redlickr = require('./redlickr.coffee')

document.addEventListener 'DOMContentLoaded', ->
  if __gaTracker?
    googleTracker = __gaTracker
  else
    googleTracker = null
  React.renderComponent(Redlickr(googleTracker: googleTracker), document.body)
