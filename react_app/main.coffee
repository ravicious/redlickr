React = require('react')
Redlickr = require('./redlickr.coffee')

document.addEventListener 'DOMContentLoaded', ->
  React.renderComponent(Redlickr(), document.body)
