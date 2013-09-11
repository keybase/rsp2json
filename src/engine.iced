
{Scanner} = require './scanner'
{Parser} = require './parser'

#============================================

exports.Engine = class Engine

  constructor : (@filename) ->
    @scanner = new Scanner @filename
    @parser = new Parser @scanner

  run : (cb) ->
    await @scanner.open defer err
    await @parser.parse defer records unless err?
    cb err, records

#============================================
