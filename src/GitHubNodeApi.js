var hostName = "api.github.com";
var agent = "tracesOf-build-script";
var https = require("https");

// Optional auth. Unauthenticated requests are capped at 60/hour and each widget
// costs three (master 404 -> main tree -> manifest), so a plain run manages
// about 18 adds before it stalls for the rest of the hour. Setting GITHUB_TOKEN
// or GH_TOKEN raises the cap to 5000/hour. Node-only: the browser build resolves
// GitHubApi.js to GitHubBrowserApi.js, and browserify stubs process.env to {},
// so no token is ever read or bundled on the client.
var token = process.env.GITHUB_TOKEN || process.env.GH_TOKEN;

exports.getJSON = function getJSON(path, callback) {
  var opts = { hostname: hostName, path: "/" + path, method: "GET" };
  var req = https.request(opts, (res) => {
    var body = "";
    res
      .on("error", (err) => callback(err))
      .on("data", (chunk) => {
        body += chunk;
      })
      .on("end", () => {
        res.statusCode !== 200
          ? callback({ status: res.statusCode, body: body })
          : callback(null, JSON.parse(body));
      });
  });
  req.setHeader("User-Agent", agent);
  if (token) req.setHeader("Authorization", "Bearer " + token);
  req.on("error", (err) => callback(err));
  req.end();
};
