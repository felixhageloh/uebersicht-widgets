var api = require('./GitHubApi.js');

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

function parseWidgetManifest(encodedContent) {
  return JSON.parse(window.atob(encodedContent));
}

function ghRawUrl(repoData, path) {
  return [
    'https://raw.githubusercontent.com',
    repoData.user,
    repoData.repo,
    'master',
    path
  ].join('/');
}

function extractRepoData(repoUrl) {
  var parser = document.createElement('A');
  parser.href = repoUrl;
  var parts = parser.pathname.split('/');
  return {
    user: parts[1],
    repo: parts[2],
    url: repoUrl,
  };
}

function buildWidget(repoData, manifest) {
  return {
    id: repoData.repo,
    name: manifest.name,
    author: manifest.author,
    user: repoData.user,
    repo: repoData.repo,
    description: manifest.description,
    screenshotUrl: ghRawUrl(repoData, repoData.screenshotPath),
    downloadUrl: ghRawUrl(repoData, repoData.zipPath),
    repoUrl: repoData.url,
    modifiedAt: new Date().getTime(),
  };
}

module.exports = function getWidget(repoUrl, callback) {
  var repoData = extractRepoData(repoUrl);
  var user = repoData.user;
  var repoName = repoData.repo;

  api.getJSON(
    ['repos', user, repoName, 'git/trees/master'].join('/'),
    function handleRepoResponse(res) {
      var paths = parseWidgetDir(res.tree);
      api.getJSON(
        ['repos', user, repoName, 'contents', paths.manifestPath].join('/'),
        function handleManifestResponse(res) {
          var manifest = parseWidgetManifest(res.content);
          callback(
            null,
            buildWidget(Object.assign({}, repoData, paths), manifest)
          );
        }
      );
    }
  );
};
