var parseRepoUrl = require('./parseRepoUrl.js');
var parseRepo = require('./parseRepo.js');
var parseManifest = require('./parseManifest.js');
var buildWidget = require('./buildWidget.js');

module.exports = function getWidget(repoUrl) {
  var repoData = parseRepoUrl(repoUrl);

  return parseRepo(repoData)
    .then(function(res) {
      repoData = Object.assign({}, repoData, res);
      return parseManifest(repoData, repoData.manifestPath);
    })
    .then(function(manifest) {
      return buildWidget(repoData, manifest);
    })
    .catch(function(e) {
      throw e;
    });
};
