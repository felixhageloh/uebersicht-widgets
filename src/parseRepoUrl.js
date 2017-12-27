module.exports = function parseRepoUrl(repoUrl) {
  var parser;
  if (typeof document === 'undefined') {
    parser = require('url').parse(repoUrl);
  } else {
    parser = document.createElement('A');
    parser.href = repoUrl;
  }
  var parts = parser.pathname.split('/');
  return {
    user: parts[1],
    repo: parts[2],
    url: repoUrl,
  };
};
