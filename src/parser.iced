
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
    go = true
    while go
      await @src.peek defer line
      if line?.is_empty() then @src.consume()
      else go = false
    cb()

  #-----------------
  
  parse_header : (cb) ->
    await @eat_empty_lines defer()
    header = {}
    go = true
    while go
      await @src.peek defer line
      if line?.is_header()
        @src.consume()
        header[line.key()] = line.value()
      else go = false
    cb header

  #-----------------
  
  parse_clusters : (cb) ->
    res = []
    go = true
    while go
      await @parse_cluster defer cluster
      if cluster? then res.push cluster
      else go = false
    cb res

  #-----------------

  parse_cluster : (cb) ->
    await @eat_empty_lines defer()
    cluster = {}
    go = true
    while go
      await @src.peek defer line
      if line?.is_data()
        @src.consume()
        cluster[line.key()] = line.value()
        found = true
      else go = false
    cluster = null unless found
    cb cluster

#=======================================================



