React = require('react')
R = React.DOM

HistoryItem = React.createClass
  displayName: "HistoryItem"

  onClick: (e) ->
    e.preventDefault()

    @props.onHistoryItemClick(@props.item)

  render: ->
    className = 'historyItem'
    if @props.item.uuid == @props.activeItemUuid
      className += ' active'

    R.div {className: className},
      R.a {onClick: @onClick, href: '#historyItem'}, @props.item.title

module.exports = HistoryItem
