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
          'js/punchdrunk.js': [
            'coffeescript/punchdrunk.coffee'
            'coffeescript/love.js/*.coffee',
            'coffeescript/love.js/audio/*.coffee',
            'coffeescript/love.js/graphics/*.coffee',
            'coffeescript/love.js/filesystem/*.coffee',
            'coffeescript/love.js/image/*.coffee',
          ]
    concat:
      banner:
        options:
          banner: '<%= banner %>'
        src: ['js/moonshine.js', 'js/sylvester.src.js', 'js/punchdrunk.js']
        dest: 'js/punchdrunk.js'
    watch:
      coffeescript:
        files: ['coffeescript/**/*.coffee', 'coffeescript/*.coffee']
        tasks: ['coffee:app']
      game:
        files: ['lua/*.lua']
        tasks: ['shell:distil_game']
      bootstrap:
        files: ['js/boot.lua']
        tasks: ['shell:distil_bootstrap']
    shell:
      distil_game:
        command: './node_modules/moonshine/bin/moonshine distil -d lua lua'
      distil_bootstrap:
        command: './node_modules/moonshine/bin/moonshine distil -o js/boot.lua.json js/boot.lua'
      distil_examples:
        command: './node_modules/moonshine/bin/moonshine distil -d examples examples'
    connect:
      server:
        options:
          port: 8000
          base: '.'

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-shell')

  grunt.registerTask 'default', ['coffee', 'shell', 'connect:server', 'watch']
  grunt.registerTask 'compile', ['coffee', 'shell']
