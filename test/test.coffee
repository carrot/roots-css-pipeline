path   = require 'path'
fs     = require 'fs'
should = require 'should'
Roots  = require 'roots'
_path     = path.join(__dirname, 'fixtures')
RootsUtil = require 'roots-util'
h = new RootsUtil.Helpers(base: _path)

# setup, teardown, and utils

compile_fixture = (fixture_name, done) ->
  @public = path.join(fixture_name, 'public')
  h.project.compile(Roots, fixture_name).done(done)

before (done) ->
  h.project.install_dependencies('*', done)

after ->
  h.project.remove_folders('**/public')

# tests

describe 'development', ->

  before (done) -> compile_fixture.call(@, 'development', -> done())

  it 'css function should output a tag for each file', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, 'css/test.css').should.be.ok
    h.file.contains(p, 'css/wow.css').should.be.ok

  it 'files should have correct content', ->
    p1 = path.join(@public, 'css/test.css')
    p2 = path.join(@public, 'css/wow.css')
    h.file.exists(p1).should.be.ok
    h.file.contains(p1, 'color: #f00;').should.be.ok
    h.file.exists(p2).should.be.ok
    h.file.contains(p2, 'background: #008000;').should.be.ok

describe 'concat', ->

  before (done) -> compile_fixture.call(@, 'concat', -> done())

  it 'css function should output a tag for the build file', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, 'build.css').should.be.ok

  it 'build file should have correct content', ->
    p = path.join(@public, 'css/build.css')
    h.file.exists(p).should.be.ok
    h.file.contains(p, 'color: #f00;').should.be.ok
    h.file.contains(p, 'background: #008000;').should.be.ok

describe 'concat-minify', ->

  before (done) -> compile_fixture.call(@, 'concat-minify', -> done())

  it 'css function should output a tag for the build file', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, 'build.min.css').should.be.ok

  it 'build file should have correct content', ->
    p = path.join(@public, 'css/build.min.css')
    h.file.exists(p).should.be.ok
    h.file.contains(p, '.wow{background:green}').should.be.ok
    h.file.contains(p, 'p{color:red}').should.be.ok

describe 'hash', ->

  before (done) -> compile_fixture.call(@, 'hash', -> done())

  it 'css function should output a tag for the hashed build file', ->
    p = path.join(@public, 'index.html')
    filename = fs.readdirSync(path.join(_path, @public, 'css'))[0]
    h.file.contains(p, filename).should.be.ok

describe 'manifest', ->

  before (done) -> compile_fixture.call(@, 'manifest', -> done())

  it 'css function should output a tag for each file', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, 'b-strizzle.css').should.be.ok
    h.file.contains(p, 't-nizzle.css').should.be.ok
    h.file.contains(p, 'test.css').should.be.ok
    h.file.contains(p, 'wow.css').should.be.ok

  it 'files should have correct content', ->
    p1 = path.join(@public, 'css/test.css')
    p2 = path.join(@public, 'css/wow.css')
    p3 = path.join(@public, 'css/b-strizzy/b-strizzle.css')
    p4 = path.join(@public, 'css/b-strizzy/t-nizzle.css')
    h.file.exists(p1).should.be.ok
    h.file.contains(p1, "color: #f00").should.be.ok
    h.file.exists(p2).should.be.ok
    h.file.contains(p2, 'background: #008000').should.be.ok
    h.file.exists(p3).should.be.ok
    h.file.contains(p3, "color: blue").should.be.ok
    h.file.exists(p4).should.be.ok
    h.file.contains(p4, 'content: "tizzle wizzle fizzle lizzle"').should.be.ok

  it 'manifest file should be ignored from output', ->
    h.file.doesnt_exist(path.join(@public, 'css/manifest.yml')).should.be.ok

describe 'concat-manifest', ->

  before (done) -> compile_fixture.call(@, 'concat-manifest', -> done())

  it 'css function should output a tag for the build file', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, 'css/build.css').should.be.ok

  it 'build file should have correct content', ->
    p = path.join(@public, 'css/build.css')
    h.file.exists(p).should.be.ok
    h.file.contains(p, '.bootstripe {\n  color: blue;\n}\nbody:after {\n  content: "tizzle wizzle fizzle lizzle"\n}\n.wow {\n  background: #008000;\n}\np {\n  color: #f00;\n}\n').should.be.ok

describe 'prefix', ->

  before (done) -> compile_fixture.call(@, 'prefix', -> done())

  it 'should prefix output path with whatever is passed to the css function', ->
    p = path.join(@public, 'index.html')
    h.file.contains(p, "href='/css/build.css'").should.be.ok

describe 'file-ext', ->

  before (done) -> compile_fixture.call(@, 'file-ext', -> done())

  it 'should remove all file extensions, and replace it with .css', ->
    p1 = path.join(@public, 'css/main.css')
    p2 = path.join(@public, 'css/wow.css')
    p3 = path.join(@public, 'css/foo.css')

    h.file.exists(p1).should.be.ok
    h.file.exists(p2).should.be.ok
    h.file.exists(p3).should.be.ok
