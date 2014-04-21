React = require('react/addons')
R = React.DOM

HistoryItem = React.createClass
  displayName: "HistoryItem"

  onClick: (e) ->
    e.preventDefault()

    @props.onHistoryItemClick(@props.item)

  isActiveItem: ->
    @props.item.uuid == @props.activeItemUuid

  render: ->
    classes = React.addons.classSet
      'historyItem': true
      'active': @isActiveItem()

    R.div {className: classes},
      R.a {onClick: @onClick, href: '#historyItem'}, @props.item.title

module.exports = HistoryItem
