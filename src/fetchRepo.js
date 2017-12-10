var api = require('./GitHubApi.js');

module.exports = function fetchRepo(repoData) {
  return new Promise(function(resolve, reject) {
    api.getJSON(
      ['repos', repoData.user, repoData.repo, 'git/trees/master'].join('/'),
      function handleRepoResponse(err, repoRes) {
        err ? reject(err) : resolve(repoRes);
      }
    );
  });
};
