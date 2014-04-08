(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/


// private property
_keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

// public method for encoding
exports.encode = function (input) {
    var output = "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;

    input = _utf8_encode(input);

    while (i < input.length) {

        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }

        output = output +
        _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
        _keyStr.charAt(enc3) + _keyStr.charAt(enc4);

    }

    return output;
}

// public method for decoding
exports.decode = function (input) {
    var output = "";
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;

    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

    while (i < input.length) {

        enc1 = _keyStr.indexOf(input.charAt(i++));
        enc2 = _keyStr.indexOf(input.charAt(i++));
        enc3 = _keyStr.indexOf(input.charAt(i++));
        enc4 = _keyStr.indexOf(input.charAt(i++));

        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;

        output = output + String.fromCharCode(chr1);

        if (enc3 != 64) {
            output = output + String.fromCharCode(chr2);
        }
        if (enc4 != 64) {
            output = output + String.fromCharCode(chr3);
        }

    }

    output = _utf8_decode(output);

    return output;

}

// private method for UTF-8 encoding
function _utf8_encode (string) {
    string = string.replace(/\r\n/g,"\n");
    var utftext = "";

    for (var n = 0; n < string.length; n++) {

        var c = string.charCodeAt(n);

        if (c < 128) {
            utftext += String.fromCharCode(c);
        }
        else if((c > 127) && (c < 2048)) {
            utftext += String.fromCharCode((c >> 6) | 192);
            utftext += String.fromCharCode((c & 63) | 128);
        }
        else {
            utftext += String.fromCharCode((c >> 12) | 224);
            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
            utftext += String.fromCharCode((c & 63) | 128);
        }

    }

    return utftext;
}

// private method for UTF-8 decoding
function _utf8_decode (utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;

    while ( i < utftext.length ) {

        c = utftext.charCodeAt(i);

        if (c < 128) {
            string += String.fromCharCode(c);
            i++;
        }
        else if((c > 191) && (c < 224)) {
            c2 = utftext.charCodeAt(i+1);
            string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
            i += 2;
        }
        else {
            c2 = utftext.charCodeAt(i+1);
            c3 = utftext.charCodeAt(i+2);
            string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            i += 3;
        }

    }

    return string;
}

},{}],2:[function(require,module,exports){
var b64, baseUrl, reqId;

b64 = require('./base64.js');

baseUrl = 'https://api.github.com';

reqId = 0;

module.exports = function(user, repo) {
  var api, makeRequest;
  api = {};
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
  api.get = function(url, callback) {
    return makeRequest(url, callback);
  };
  api.getTree = function(sha, callback) {
    return makeRequest("/repos/" + user + "/" + repo + "/git/trees/" + sha, function(data) {
      return callback(data.tree);
    });
  };
  api.getContent = function(path, callback) {
    return makeRequest("/repos/" + user + "/" + repo + "/contents/" + path, function(data) {
      return callback(b64.decode(data.content));
    });
  };
  api.rawUrl = function(path) {
    return "https://raw.githubusercontent.com/" + user + "/" + repo + "/master/" + path;
  };
  return api;
};


},{"./base64.js":1}],3:[function(require,module,exports){
var GH, getAndRenderWidgets, getLastCommit, getWidget, gh, renderWidget, repo, user, widgetTemplate;

GH = require('./gh.coffee');

user = 'felixhageloh';

repo = 'uebersicht-widgets';

gh = GH(user, repo);

getLastCommit = function(callback) {
  return gh.get("/repos/" + user + "/" + repo + "/git/refs/heads/master", function(data) {
    return callback(data.object.sha);
  });
};

getAndRenderWidgets = function(tree) {
  var entry, _i, _len, _results;
  _results = [];
  for (_i = 0, _len = tree.length; _i < _len; _i++) {
    entry = tree[_i];
    if (entry.type !== 'tree') {
      continue;
    }
    _results.push(getWidget(entry.sha, entry.path, renderWidget));
  }
  return _results;
};

getWidget = function(sha, path, callback) {
  var getManifest, parseEntry, widget;
  widget = {};
  parseEntry = function(entry) {
    if (entry.path.indexOf('screenshot') > -1) {
      widget.screenshot = path + '/' + entry.path;
    }
    if (entry.path.indexOf('widget.json') > -1) {
      return widget.manifest = path + '/' + entry.path;
    }
  };
  getManifest = function(path, callback) {
    return gh.getContent(path, function(manifest) {
      manifest = JSON.parse(manifest);
      widget.name = manifest.name;
      widget.description = manifest.description;
      return callback(widget);
    });
  };
  return gh.getTree(sha, function(tree) {
    var entry, _i, _len;
    for (_i = 0, _len = tree.length; _i < _len; _i++) {
      entry = tree[_i];
      parseEntry(entry);
    }
    return getManifest(widget.manifest, callback);
  });
};

renderWidget = function(widget) {
  return $(document.body).append(widgetTemplate(widget));
};

widgetTemplate = function(widget) {
  return "<div style='border: 1px solid #ccc'>\n  <p>" + widget.name + "</p>\n  <p>" + widget.description + "</p>\n  <img src='" + (gh.rawUrl(widget.screenshot)) + "'/>\n</div>";
};

$(function() {
  return getLastCommit(function(sha) {
    return gh.getTree(sha, getAndRenderWidgets);
  });
});


},{"./gh.coffee":2}]},{},[3])