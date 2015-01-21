css_pipeline = require '../../..'

module.exports =
  ignores: ["**/_*", "**/.DS_Store"]
  extensions: [css_pipeline(files: "css/**", out: 'css/build.css')]
