var baseUrl = "https://api.github.com";
var currentCallback;
var busy = false;

window.githubApiCallback = function githubApiCallback(json) {
  busy = false;
  if (!currentCallback) {
    return;
  }
  json.meta.status < 300
    ? currentCallback(null, json.data)
    : currentCallback({ ...json.data, status: json.meta.status });
};

exports.getJSON = function getJSON(path, callback) {
  if (busy) {
    throw new Error("API request already in progress.");
  }
  busy = true;
  var script = document.createElement("SCRIPT");
  script.src = baseUrl + "/" + path + "?callback=githubApiCallback";
  document.body.appendChild(script);
  currentCallback = callback;
};
