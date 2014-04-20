lodash = require('lodash')

wordFilter = {
  lodash: lodash

  filter: (string, wordsArray) ->
    splittedString = string.toLowerCase().split /\b/
    filteredString = @lodash.without(splittedString, wordsArray...).join("")
    # get rid of unnecessary spaces
    filteredString.replace(/\s{2,}/g, " ").replace(/(^\s|\s$)/g, "")
}

module.exports = wordFilter
