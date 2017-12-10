module.exports = function parseRepoUrl(repoUrl) {
  var parser = document.createElement('A');
  parser.href = repoUrl;
  var parts = parser.pathname.split('/');
  return {
    user: parts[1],
    repo: parts[2],
    url: repoUrl,
  };
};
