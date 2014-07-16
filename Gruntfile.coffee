module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    banner: """/*! <%= pkg.name %> <%= pkg.version %> (<%= grunt.template.today('yyyy-mm-dd') %>) - <%= pkg.homepage %> */
            /*! <%= pkg.description %> */
            /*! <%= pkg.author %> */"""
    coffee:
      app:
        options:
          banner: '<%= banner %>'
          join: true
        files:
          'js/love.js': [
            'coffeescript/punchdrunk.coffee',
            'coffeescript/love.coffee',
            'coffeescript/love.js/*.coffee',
            'coffeescript/love.js/audio/*.coffee',
            'coffeescript/love.js/graphics/*.coffee',
            'coffeescript/love.js/filesystem/*.coffee',
            'coffeescript/love.js/image/*.coffee',
            'coffeescript/love.js/math/*.coffee',
          ]
      tests:
        files:
          'test/tests.js': [
            'test/src/*.coffee',
            'test/src/**/*.coffee'
          ]
    concat:
      punchdrunk:
        options:
          banner: '<%= banner %>'
        src: ['js/moonshine.js', 'js/sylvester.src.js', 'js/simplex-noise.js', 'js/long.js', 'js/love.js']
        dest: 'js/punchdrunk.js'
    watch:
      coffeescript:
        files: ['coffeescript/**/*.coffee', 'coffeescript/*.coffee']
        tasks: ['coffee:app', 'concat:punchdrunk']
      game:
        files: ['lua/*.lua']
        tasks: ['distil_game']
      bootstrap:
        files: ['js/boot.lua']
        tasks: ['distil_bootstrap']
      examples:
        files: ['examples/**/*.lua']
        tasks: ['distil_examples']
    connect:
      server:
        options:
          port: 8000
    mocha_phantomjs:
       all: ['test/*.html']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-mocha-phantomjs')

  grunt.registerTask 'default', ['compile', 'connect:server', 'watch']
  grunt.registerTask 'compile', ['coffee:app', 'concat', 'distil_game', 'distil_bootstrap', 'distil_examples']
  grunt.registerTask 'test', ['coffee', 'concat', 'mocha_phantomjs']

  distil = require('moonshine/bin/commands/distil.js')
  grunt.registerTask 'distil_game', ->
    done = @async()
    distil.parseCommand
      switches:
        outputFilename: ''
        outputPath: 'lua'
        jsonFormat: false
        packageMain: ''
        noRecursion: false
        stripDebugging: false
        watch: false
      filenames: [ 'lua' ], ->
        done()

  grunt.registerTask 'distil_bootstrap', ->
    done = @async()
    distil.parseCommand
      switches:
        outputFilename: 'js/boot.lua.json'
        outputPath: '.'
        jsonFormat: false
        packageMain: ''
        noRecursion: false
        stripDebugging: false
        watch: false
      filenames: [ 'js/boot.lua' ], ->
        done()

  grunt.registerTask 'distil_examples', ->
    done = @async()
    distil.parseCommand
      switches:
        outputFilename: ''
        outputPath: 'examples'
        jsonFormat: false
        packageMain: ''
        noRecursion: false
        stripDebugging: false
        watch: false
      filenames: [ 'examples' ], ->
        done()
