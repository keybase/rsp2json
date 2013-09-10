
[NONE, HEADER, DATA, SEP] = [0...4]

exports.Parser = class Parser

  constructor : (@src) ->

  parse : () ->
    records = []
    until @src.eof()
      header = @parse_header()
      data = @parse_data()
      records.push { header, data }
    records

  eat_empty_lines : () ->
    while @src.peek().is_empty()
      @src.get_line()

  parse_header : () ->
    @eat_empty_lines()
