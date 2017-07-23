var baseUrl = 'https://api.github.com';
var currentCallback;

window.githubApiCallback = function githubApiCallback(json) {
  if (currentCallback) {
    currentCallback(json.data);
  }
};

exports.getJSON = function getJSON(path, callback) {
  var script = document.createElement('SCRIPT');
  script.src = baseUrl + '/' + path + '?callback=githubApiCallback';
  document.body.appendChild(script);
  currentCallback = callback;
};
