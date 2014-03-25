fs        = require 'fs'
path      = require 'path'
_         = require 'lodash'
minimatch = require 'minimatch'
CleanCSS  = require 'clean-css'
crypto    = require 'crypto'
RootsUtil  = require 'roots-util'

module.exports = (opts) ->

  opts = _.defaults opts,
    files: 'assets/css/**'
    out: false
    minify: false
    hash: false
    opts: {}

  class CSSPipeline

    ###*
     * Sets up the custom category and view function.
     * The view function grabs either the single output path or collects
     * all non-ignored output paths for the input files and returns them
     * as html link tags.
     * 
     * @param  {Function} @roots - Roots class instance
    ###

    constructor: (@roots) ->
      @category = 'css-pipeline'
      @contents = ''
      @util = new RootsUtil(@roots)

      @roots.config.locals ?= {}
      @roots.config.locals.css = =>
        paths = []

        if opts.out
          paths.push(opts.out)
        else
          files = @util.files(opts.files)
          files = files.map((f) => path.sep + @util.output_path(f.relative, 'css').relative)
          paths = paths.concat(files)
        
        paths.map((p) -> "<link rel='stylesheet' src='#{p}' />").join("\n")

    ###*
     * Minimatch runs against each path, quick and easy.
    ###

    fs: ->
      extract: true
      detect: (f) -> minimatch(f.relative, opts.files)

    ###*
     * After compile, if concat is happening, grab the contents and save them
     * away, then prevent write.
    ###

    compile_hooks: ->
      after_file: (ctx) => if opts.out then @contents += ctx.content
      write: -> !opts.out

    ###*
     * Write the output file if necessary.
    ###

    category_hooks: ->
      after: (ctx) =>
        if not opts.out then return

        if opts.minify then @contents = (new CleanCSS(opts.opts)).minify(@contents)

        if opts.hash
          hash = crypto.createHash('md5').update(@contents, 'utf8')
          res = opts.out.split('.')
          res.splice(-1, 0, hash.digest('hex'))
          opts.out = res.join('.')

        @util.write(opts.out, @contents)
