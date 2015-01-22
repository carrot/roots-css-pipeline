Roots CSS Pipeline
==================

[![npm](http://img.shields.io/npm/v/css-pipeline.svg?style=flat)](https://badge.fury.io/js/css-pipeline) [![tests](http://img.shields.io/travis/carrot/roots-css-pipeline/master.svg?style=flat)](https://travis-ci.org/carrot/roots-css-pipeline) [![coverage](http://img.shields.io/coveralls/carrot/roots-css-pipeline.svg?style=flat)](https://coveralls.io/r/carrot/roots-css-pipeline) [![dependencies](http://img.shields.io/gemnasium/carrot/roots-css-pipeline.svg?style=flat)](https://gemnasium.com/carrot/roots-css-pipeline)

Roots css pipeline is an asset pipeline for css files which optionally concatenates and/or minifies css files for production builds.

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

This extension provides a way for you to pass it a list of css files that you want to include in your project, allows you to optionally concatenate, minify, and/or hash them, and exposes a `css` function to all views that prints the path or paths to your css file or files.

In general, this plugin is used in two ways, "development" and "production" modes. In development, the files are just linked through without concatenation or minification. In production, the files are concatenated, minifed, and a single file is linked. You can switch between these seamlessly using different plugin options and without having to change any view code at all.

Since the extension aims to be flexible to as many styles as possible, there are often a few different ways to do things, which are walked through below.

#### Specifying Files

The first step is usually specifying which files you need in your project. This can be done either _in app.coffee_ by passing a minimatch string or array of minimatch strings as the `files` option, or in a separate file we call a **manifest file** by passing a path to the manifest file as a `manifest` option, and having the manifest file contain a yaml-formatted array of minimatch strings. Let's look at an example of how each of these two would look, starting with using the `files` key. But first, here's how our css files are organized for these examples:

```
assets
˻ css
  ˻ main.styl
  ˻ vendor
    ˻ bootstrap
      ˻ bootstrap.min.css
      ˻ extra.min.css
    ˻ bootstrap.plugin.min.css
```

Ok, now a couple possible configurations using the `files` key:

```coffee
css_pipeline = require('css-pipeline')

# this example uses a single globstar path
module.exports =
  extensions: [css_pipeline(files: 'assets/css/**/*')]
```

```coffee
css_pipeline = require('css-pipeline')

# this example uses an array of paths
module.exports =
  extensions: [
    css_pipeline(files: ['assets/css/vendor/**', 'assets/css/main.styl'])
  ]
```

You can pass `files` either a string or array of strings, they should point to paths in your project source, and they can include globstars that are parsed by [minimatch](https://github.com/isaacs/minimatch) if you want. If you are using an array, the scripts will be loaded in the order that the array is in. For any globstar matches that a minimatch string makes, the files are loaded in an arbitrary order. So if your `main.styl` file depended on bootstrap, the second example would be a more reliable way to load the two scripts to ensure that bootstrap loads before main.styl.

Now let's look at an example of using a manifest file, assuming that we now have a manifest file in our css folder like this:

```
assets
˻ css
  ˻ manifest.yml
  ˻ main.styl
  ˻ vendor
    ˻ bootstrap
      ˻ bootstrap.min.css
      ˻ extra.min.css
    ˻ bootstrap.plugin.min.css
```

And that the manifest file might look like this:

```yml
# manifest.yml
- vendor/bootstrap/*
- vendor/bootstrap.plugin.min.css
- main.styl
```

And your roots config might look like this:

```coffee
# app.coffee
css_pipeline = require('css-pipeline')

module.exports =
  extensions: [css_pipeline(manifest: "assets/css/manifest.yml")]
```

The manifest file's contents are just a yaml array, and it's parsed in the same way as if you had passed an array to the `files` key. You might have also noticed that the root for all the file paths in the manifest file is the directory that the manifest file is in itself, so we didn't have to specify `assets/css` on each one.

You can name the manifest file whatever you'd like, the filename and extension don't matter as long as the contents are valid yaml.

#### Injecting Scripts Into Views

When you use this extension, it will expose a function called `css` to all your view files. When you call this function, the extension will drop in one or more link tags pointing to your scripts. If you specified an `out` path, it will build all your input files into that file and drop a single link tag pointing to it. If not, it will link to each of your input files.

Note that the `css` function accepts one optional argument, which is a path to prefix any injected scripts with. So for example if you wanted to have stylesheets load from the root of the site, you could pass in `/`. By default, it would be the relative path `css/master.css`, but calling with `/` would make it `/css/master.css`.

Here's an example of using the `css` function. This example uses [jade](http://jade-lang.com/) but this will also work with any other templating language.

```jade
//- index.jade
p here's my great website
!= css()
```

Now let's take a look at some sample output. With this configuration:

```coffee
# app.coffee
css_pipeline = require('css-pipeline')

module.exports =
  extensions: [css_pipeline(files: 'assets/css/**', out: 'css/build.css')]
```

You would see this output, with the build file having all your input's matches concatenated together.

```html
<!-- public/index.html -->
<p>here's my great website</p>
<link rel='stylesheet' href='/css/build.css' />
```

And without the `out` path, as such:

```coffee
# app.coffee
css_pipeline = require('css-pipeline')

module.exports =
  extensions: [css_pipeline(files: 'assets/css/**')]
```

You might see output like this, with each file loaded on its own:

```html
<!-- public/index.html -->
<p>here's my great website</p>
<link rel='stylesheet' href='/css/foo.css' />
<link rel='stylesheet' href='/css/bar.css' />
<link rel='stylesheet' href='/css/baz.css' />
```

### Options

##### files
String or array of strings ([minimatch](https://github.com/isaacs/minimatch) supported) pointing to one or more file paths to be built.

##### manifest
A path, relative to the roots project's root, to a _manifest file_ (explained above), which contains a list of strings ([minimatch](https://github.com/isaacs/minimatch) supported) pointing to one more more file paths to be built.

##### out
If provided, all input files will be concatenated to this single path. Default is `false`

##### minify
Minfifies the output. Default is `false`.

##### opts
Options to be passed into the minifier. Only does anything useful when minify is true. Possible options can be seen [here](https://github.com/GoalSmashers/clean-css#how-to-use-clean-css-programmatically).

##### hash
Boolean, and only works when `out` is also defined. Hashes the file contents and appends to the filename. This is typically used for cache-busting. Always puts the hash before the final extension, for example `file.x.y.HASH.css`. The hash is a lengthy string of random numbers and letters, and the name change is automatically reflected by the `css` function in your views. Default is `false`.

### License & Contributing

- Details on the license [can be found here](LICENSE.md)
- Details on running tests and contributing [can be found here](contributing.md)
