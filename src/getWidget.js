var fetchRepo = require('./fetchRepo.js');
var parseRepoUrl = require('./parseRepoUrl.js');
var parseRepo = require('./parseRepo.js');
var parseManifest = require('./parseManifest.js');
var buildWidget = require('./buildWidget.js');

module.exports = function getWidget(repoUrl, progressCb) {
  var cb = progressCb || function() {};
  var repoData = parseRepoUrl(repoUrl);
  var progressData = {};
  var step = 'repoFound';
  return fetchRepo(repoData)
    .then(function(res) {
      progressData[step] = true;
      cb(progressData);
      step = 'repoValid';
      return parseRepo(res);
    })
    .then(function(res) {
      progressData[step] = true;
      cb(progressData);
      repoData = Object.assign({}, repoData, res);
      step = 'manifest';
      return parseManifest(repoData, repoData.manifestPath);
    })
    .then(function(manifest) {
      progressData[step] = true;
      cb(progressData);
      step = undefined;
      return buildWidget(repoData, manifest);
    })
    .catch(function(err) {
      var errObj = {err: err};
      errObj[step] = true;
      throw errObj;
    });
};
