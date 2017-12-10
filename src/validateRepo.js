module.exports = function validateRepo(repoPaths) {
  var errors = [];

  repoPaths.screenshotPath || errors.push('screenshot');
  repoPaths.manifestPath || errors.push('manifest');
  repoPaths.zipPath || errors.push('zip');

  return errors;
};
