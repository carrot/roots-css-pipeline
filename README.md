Roots CSS Pipeline
==================

[![npm](https://badge.fury.io/js/css-pipeline.png)](http://badge.fury.io/js/css-pipeline) [![tests](https://travis-ci.org/carrot/roots-css-pipeline.png?branch=master)](https://travis-ci.org/carrot/roots-css-pipeline) [![dependencies](https://david-dm.org/carrot/roots-css-pipeline.png?theme=shields.io)](https://david-dm.org/carrot/roots-css-pipeline)

Roots css pipeline is an assep pipeline for css files which optionally concatenates, minifies, and/or hashes css files for production builds.

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

### Installation

- make sure you are in your roots project directory
- `npm install css-pipeline --save`
- modify your `app.coffee` file to include the extension, as such

  ```coffee
  css_pipeline = require('css-pipeline')

  module.exports =
    extensions: [css_pipeline(files: "assets/css/**", out: 'css/build.css', minify: true)]
  ```

### Usage

As can be seen above, the plugin takes a [minimatch](https://github.com/isaacs/minimatch) string (or array of minimatch strings) to build it's tree of processed files. You will then have the function `css` made available in all your views, when you can execute to output the tag or tags needed. If you specify an `out` path, all the matched files will all be concatenated and that one file will be inserted into a view wherever the `css` function is called, and if not, it will individually compile each file and output tags linking to each one.

For example, in a jade view:

```jade
!= css()
//- outputs "<link rel='stylesheet' src='css/build.css' />"
//- or if no output path, link tags for each css file matched by `files`
```

### Options

##### files
String or array of strings ([minimatch](https://github.com/isaacs/minimatch) supported) pointing to one or more file paths which will serve as the base.

##### out
If provided, all input files will be concatenated to this single path. Default is `false`

##### minify
Minfifies the output. Default is `false`.

##### opts
Options to be passed into the minifier. Only does anything useful when minify is true. Possible options can be seen [here](https://github.com/GoalSmashers/clean-css#how-to-use-clean-css-programmatically).

### License & Contributing

- Details on the license [can be found here](LICENSE.md)
- Details on running tests and contributing [can be found here](contributing.md)
