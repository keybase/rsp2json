
#=======================================================

exports.Parser = class Parser

  #-----------------
  
  constructor : (@src) ->

  #-----------------
  
  parse : (cb) ->
    records = []
    until @src.eof()
      await @parse_header defer header
      await @parse_clusters defer clusters
      records.push { header, clusters }
    cb records

  #-----------------
  
  eat_empty_lines : (cb) ->
    go = True
    while go
      await @src.peek defer line
      if line?.is_empty()
        @src.consume()
      else
        go = False
    cb()

  #-----------------
  
  parse_header : (cb) ->
    await @eat_empty_lines defer()
    header = {}
    go = True
    while go
      await @src.peek defer line
      if line?.is_header()
        @src.consume()
        header[line.key()] = line.value()
      else
        go = False
    cb header

  #-----------------
  
  parse_clusters : (cb) ->
    res = []
    go = True
    while go
      await @parse_cluster defer cluster
      if cluster? then res.push cluster
      else go = False
    cb res

  #-----------------

  parse_cluster : () ->
    await @eat_empy_lines defer()
    cluster = {}
    go = True
    while go
      await @src.peek defer line
      if line?.is_data()
        @src.consume()
        cluster[line.key()] = line.value()
        found = true
      else
        go = False
    cluster = null unless found
    cb cluster

#=======================================================



