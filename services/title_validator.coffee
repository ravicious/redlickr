class TitleValidator
  constructor: (@title, @lodash, @wordFilter, @pornWords) ->

  isValid: ->
    @filteredTitle = @wordFilter.filter(@title, @pornWords)
    @validateWordsCount(@filteredTitle)

  validateWordsCount: (title = @filteredTitle) ->
    splittedString = title.split(/\s/)
    filteredWords = @lodash.filter splittedString, (word) ->
      word.length > 3

    filteredWords.length > 3

module.exports = TitleValidator
