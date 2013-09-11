
fs = require 'fs'

#=======================================================

strip = (line) ->
  line = m[1] if line? and (m = line.match /^(.*)(\s+)$/)?
  if line.match /^#/ then '' else line

#=======================================================

exports.Line = class Line

  constructor : (data) ->
    @raw = data
    unless (@_empty = !!(data.match /^\s*$/))
      if (m = data.match /^\[(.*)\]\s*$/)?
        @_header = true
        data = m[1]
      else
        @_header = false
      parts = data.split /\s*=\s*/
      @_key = parts[0]
      @_value = if parts.length > 1 then parts[1] else parts[0]

  is_header : () -> @_header
  key : () -> @_key
  value : () -> @_value
  is_empty : () -> @_empty
  is_data : () -> not @_header and not @_empty

#=======================================================

exports.Scanner = class Scanner

  constructor : (@filename) ->
    @_i = 0

  #-----------------

  open : (cb) ->
    await fs.readFile @filename, defer err, data
    unless err?
      @lines = (strip line for line in data.toString().split /\n/)
    cb err

  #-----------------

  eof : () -> (@_i >= @lines.length)

  #-----------------

  peek : (cb) ->
    ret = if @eof() then null
    else new Line @lines[@_i]
    cb ret

  #-----------------

  consume : (cb) ->
    @_i++ unless @eof()

#=======================================================
