var api = require('./GitHubApi.js');

var base64ToString = typeof window === 'undefined'
  ? (s) => Buffer.from(s, 'base64').toString()
  : (s) => window.atob(s);

module.exports = function parseManifest(repoData, manifestPath) {
  return new Promise(function(resolve, reject) {
    api.getJSON(
      ['repos', repoData.user, repoData.repo, 'contents', manifestPath].join('/'),
      function handleManifestResponse(err, res) {
        if (err) {
          return reject(err);
        }
        try {
          var manifest = JSON.parse(base64ToString(res.content));
        } catch (e) {
          return reject(e);
        }
        return resolve(manifest);
      }
    );
  });
};
