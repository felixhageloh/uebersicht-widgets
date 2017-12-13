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
    var paths = parseWidgetDir(repoData.tree);
    var errors = validateRepo(paths);
    errors ? reject(errors) : resolve(paths);
  });
};
