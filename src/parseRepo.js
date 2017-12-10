var api = require('./GitHubApi.js');
var validateRepo = require('./validateRepo.js');

function parseWidgetDir(dirTree) {
  return dirTree.reduce(function(paths, entry) {
    if (entry.path.indexOf('widget.json') > -1) {
      paths.manifestPath = entry.path;
    } else if (entry.path.indexOf('.json') > -1) {
      paths.manifestPath = entry.path;
    } else if (/screenshot\./i.test(entry.path)) {
      paths.screenshotPath = entry.path;
    } else if (entry.path.indexOf('widget.zip') > -1) {
      paths.zipPath = entry.path;
    } else if (entry.path.indexOf('.zip') > -1) {
      paths.zipPath = paths.zipPath || entry.path;
    }
    return paths;
  }, {});
}

module.exports = function parseRepo(repoData) {
  return new Promise(function(resolve, reject) {
    api.getJSON(
      ['repos', repoData.user, repoData.repo, 'git/trees/master'].join('/'),
      function handleRepoResponse(repoRes) {
        var paths = parseWidgetDir(repoRes.tree);
        var errors = validateRepo(paths);
        errors.length > 0 ? reject(errors) : resolve(paths);
      }
    );
  });
};
