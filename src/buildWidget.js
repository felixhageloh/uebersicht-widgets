function ghRawUrl(repoData, path) {
  return [
    'https://raw.githubusercontent.com',
    repoData.user,
    repoData.repo,
    'master',
    path,
  ].join('/');
}

module.exports = function buildWidget(repoData, manifest) {
  return {
    id: repoData.repo,
    name: manifest.name,
    author: manifest.author,
    user: repoData.user,
    repo: repoData.repo,
    description: manifest.description,
    screenshotUrl: ghRawUrl(repoData, repoData.screenshotPath),
    downloadUrl: ghRawUrl(repoData, repoData.zipPath),
    repoUrl: repoData.url,
    modifiedAt: new Date().getTime(),
  };
};
