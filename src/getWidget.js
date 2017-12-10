var fetchRepo = require('./fetchRepo.js');
var parseRepoUrl = require('./parseRepoUrl.js');
var parseRepo = require('./parseRepo.js');
var parseManifest = require('./parseManifest.js');
var buildWidget = require('./buildWidget.js');

module.exports = function getWidget(repoUrl, progressCb) {
  var cb = progressCb || function() {};
  var repoData = parseRepoUrl(repoUrl);
  var progressData = {};
  return fetchRepo(repoData)
    .then(function(res) {
      progressData.repoFound = true;
      cb(progressData);
      return parseRepo(res);
    })
    .then(function(res) {
      progressData.repoValid = true;
      cb(progressData);
      repoData = Object.assign({}, repoData, res);
      return parseManifest(repoData, repoData.manifestPath);
    })
    .then(function(manifest) {
      progressData.manifest = true;
      cb(progressData);
      return buildWidget(repoData, manifest);
    })
    .catch(function(e) {
      throw e;
    });
};
