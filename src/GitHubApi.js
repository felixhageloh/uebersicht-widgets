module.exports = typeof window === 'undefined'
  ? require('./GitHubNodeApi.js')
  : require('./GitHubBrowserApi');
