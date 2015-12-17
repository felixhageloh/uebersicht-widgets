Parse.initialize("uq3bFa7SvdMb3ZKWxjvU4TJmoRkUS7UY65FqybPc", "QzLq0jdERP4Y3VNadon7qYbhRjEkZbnlPBknzVH4")

DownloadCounts = Parse.Object.extend("DownloadCounts")
query          = new Parse.Query(DownloadCounts)
downloadCounts = null
cookie         = require 'cookies-js'

callbacks = []

query.get('tMDLiJERSc').then (counts) ->
  downloadCounts = counts
  cb() for cb in callbacks
  callbacks.length = 0

convertId = (id) ->
  String(id)
    .replace(/-/g, '_')
    .replace(/\./g, '_')

exports.get = (id, callback) ->
  id = convertId(id)
  return callback(downloadCounts.get(id)) if downloadCounts
  callbacks.push ->
    callback(downloadCounts.get(id))

exports.increment = (id, callback) ->
  id = convertId(id)
  return if cookie.get(id)

  doIncrement = ->
    downloadCounts.increment(id)
    downloadCounts.save().then(callback, callback)
    # should set that only when save succeeds, but it fails always
    # on safari, because of Github links
    cookie.set(id, true)

  if downloadCounts
    doIncrement()
  else
    callbacks.push doIncrement

