css_pipeline = require '../../..'

module.exports =
  ignores: ["**/_*", "**/.DS_Store"]
  extensions: [css_pipeline(manifest: "css/manifest.yml", out: 'css/build.css')]
