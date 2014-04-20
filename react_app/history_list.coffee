React = require('react')
HistoryItem = require('./history_item.coffee')
R = React.DOM

HistoryList = React.createClass
  displayName: "HistoryList"

  render: ->
    visibilityClass = if @props.visible then 'visible' else 'hidden'
    R.div {className: "historyList #{visibilityClass}"},
      [
        @props.historyItems.map (item) =>
          HistoryItem
            key: item.uuid
            item: item
            onHistoryItemClick: @props.onHistoryItemClick
            activeItemUuid: @props.activeItemUuid
      ]

module.exports = HistoryList
