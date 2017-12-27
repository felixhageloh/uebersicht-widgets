var hostName = 'api.github.com';
var agent = 'tracesOf-build-script';
var https = require('https');

exports.getJSON = function getJSON(path, callback) {
  var opts = {hostname: hostName, path: '/' + path, method: 'GET'};
  var req = https.request(opts, res => {
    var body = '';
    res
      .on('error', err => callback(err))
      .on('data', chunk => { body += chunk; })
      .on('end', () => {
        if (res.statusCode !== 200) {
          return callback(body);
        }
        return callback(null, JSON.parse(body));
      });
  });
  req.setHeader('User-Agent', agent);
  req.on('error', err => callback(err));
  req.end();
};
