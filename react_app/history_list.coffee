React = require('react/addons')
HistoryItem = require('./history_item.coffee')
R = React.DOM

HistoryList = React.createClass
  displayName: "HistoryList"

  render: ->
    classes = React.addons.classSet
      'historyList': true
      'hidden': !@props.visible
    R.div {className: classes},
      [
        @props.historyItems.map (item) =>
          HistoryItem
            key: item.uuid
            item: item
            onHistoryItemClick: @props.onHistoryItemClick
            activeItemUuid: @props.activeItemUuid
      ]

module.exports = HistoryList
