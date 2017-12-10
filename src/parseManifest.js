var api = require('./GitHubApi.js');

module.exports = function parseManifest(repoData, manifestPath) {
  return new Promise(function(resolve, reject) {
    api.getJSON(
      ['repos', repoData.user, repoData.repo, 'contents', manifestPath].join('/'),
      function handleManifestResponse(err, res) {
        if (err) {
          return reject(err);
        }
        try {
          var manifest = JSON.parse(window.atob(res.content));
        } catch (e) {
          return reject(e);
        }
        return resolve(manifest);
      }
    );
  });
};
