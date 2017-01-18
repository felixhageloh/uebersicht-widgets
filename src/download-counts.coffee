cookie = require 'cookies-js'
config =
  apiKey: "AIzaSyCRnz4xSIDk4pyAZ6oSE74a3Jk0V7-AmnE"
  authDomain: "eighth-keyword-620.firebaseapp.com"
  databaseURL: "https://eighth-keyword-620.firebaseio.com"
  storageBucket: "eighth-keyword-620.appspot.com"
  messagingSenderId: "877022320055"
firebase.initializeApp(config)
db = firebase.database()
widgetDownloadsRef = firebase.database().ref('widgetDownloads/')

downloadCounts = null
callbacks = []

widgetDownloadsRef.once('value')
  .then (counts) ->
    downloadCounts = counts.val()
    cb() for cb in callbacks
    callbacks.length = 0
  .catch (err) -> console.warn err

convertId = (id) ->
  String(id)
    .replace(/-/g, '_')
    .replace(/\./g, '_')

exports.get = get = (id, callback) ->
  id = convertId(id)
  return callback(downloadCounts[id]) if downloadCounts
  callbacks.push ->
    callback(downloadCounts[id])

exports.increment = (id, callback) ->
  id = convertId(id)
  return if cookie.get(id)
  debounce = null
  widgetDownloadsRef.child(id).transaction (count) ->
    newCount = (count || 0) + 1
    cookie.set(id, true)
    callback?(newCount) if count or !downloadCounts[id]
    return newCount
