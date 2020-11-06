var api = require("./GitHubApi.js");

const fetchTree = (user, repo, sha) => {
  return new Promise(function (resolve, reject) {
    api.getJSON(
      ["repos", user, repo, "git/trees", sha].join("/"),
      function handleRepoResponse(err, repoRes) {
        err ? reject(err) : resolve(repoRes);
      }
    );
  });
};

module.exports = function fetchRepo(repoData) {
  return fetchTree(repoData.user, repoData.repo, "master").catch((err) => {
    if (err.status !== 404) throw err;
    return fetchTree(repoData.user, repoData.repo, "main");
  });
};
