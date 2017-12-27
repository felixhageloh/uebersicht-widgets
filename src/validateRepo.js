module.exports = function validateRepo(repoPaths) {
  var errors = {};
  errors.screenshot = !repoPaths.screenshotPath;
  errors.manifest = !repoPaths.manifestPath;
  errors.zip = !repoPaths.zipPath;

  return Object.keys(errors).map(k => errors[k]).filter(e => e).length > 0
    ? errors
    : undefined
    ;
};
