module.exports = function validateRepo(repoPaths) {
  var errors = [];

  repoPaths.screenshotPath || errors.push('screenshot');
  repoPaths.manifestPath || erros.push('manifest');
  repoPaths.zipPath || erros.push('manifest');

  return errors;
};
