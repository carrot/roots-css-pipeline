path       = require 'path'
fs         = require 'fs'
W          = require 'when'
_          = require 'lodash'
# RootsUtil  = require 'roots-util'

module.exports = (opts) ->

  opts = _.defaults opts,
    files: 'assets/css/**'
    out: false
    minify: false

  class CSSPipeline

    ###*
     * Sets up the custom category and view function.
     * 
     * @param  {Function} @roots - Roots class instance
    ###

    constructor: (@roots) ->
      @category = 'css-pipeline'
      @contents = ''
      # @util = new RootsUtil(@roots)
      # inject the view function here?

    ###*
     * Minimatch runs against each path, quick and easy.
    ###

    fs: ->
      extract: true
      detect: (f) ->
        minimatch(f.relative, opts.files)

    ###*
     * After compile, if concat is happening, grab the contents and save them
     * away, then prevent write.
    ###

    compile_hooks: ->
      before_file: (ctx) -> ctx.content = ''
      write: -> false

    ###*
     * Write the output file if necessary.
    ###

    category_hooks: ->
      after: (ctx) =>
        # write the output file here
        # if opts.out then @util.write(opts.out, @contents)
