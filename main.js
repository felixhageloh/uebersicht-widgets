(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var baseUrl, makeRequest, reqId;

baseUrl = 'https://api.github.com';

reqId = 0;

makeRequest = function(url, callback) {
  var callbackName, script, sep;
  callbackName = "ghCallback" + (reqId++);
  script = document.createElement('script');
  sep = url.indexOf('?') > -1 ? '&' : '?';
  script.src = "" + baseUrl + url + sep + "callback=" + callbackName;
  window[callbackName] = function(data) {
    callback(data.data);
    script.parentNode.removeChild(script);
    return delete window[callbackName];
  };
  return document.body.appendChild(script);
};

exports.get = function(url, callback) {
  return makeRequest(url, callback);
};


},{}],2:[function(require,module,exports){
var getLastCommit, getTree, gh, renderTree, repo;

gh = require('./gh.coffee');

repo = '/repos/felixhageloh/uebersicht-widgets/git';

getLastCommit = function(callback) {
  return gh.get("" + repo + "/refs/heads/master", function(data) {
    return callback(data.object.sha);
  });
};

getTree = function(sha, callback) {
  return gh.get("" + repo + "/trees/" + sha + "?recursive=1", function(data) {
    return callback(data.tree);
  });
};

renderTree = function(tree) {
  var entry, _i, _len, _results;
  _results = [];
  for (_i = 0, _len = tree.length; _i < _len; _i++) {
    entry = tree[_i];
    _results.push($(document.body).append("<p>" + entry.path + "</p>"));
  }
  return _results;
};

$(function() {
  return getLastCommit(function(sha) {
    return getTree(sha, renderTree);
  });
});


},{"./gh.coffee":1}]},{},[2])