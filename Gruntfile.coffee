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
            'coffeescript/punchdrunk.coffee'
            'coffeescript/love.js/*.coffee',
            'coffeescript/love.js/audio/*.coffee',
            'coffeescript/love.js/graphics/*.coffee',
            'coffeescript/love.js/filesystem/*.coffee',
            'coffeescript/love.js/image/*.coffee',
          ]
    concat:
      punchdrunk:
        options:
          banner: '<%= banner %>'
        src: ['js/moonshine.js', 'js/sylvester.src.js', 'js/simplex-noise.js', 'js/love.js']
        dest: 'js/punchdrunk.js'
    watch:
      coffeescript:
        files: ['coffeescript/**/*.coffee', 'coffeescript/*.coffee']
        tasks: ['coffee:app', 'concat:punchdrunk']
      game:
        files: ['lua/*.lua']
        tasks: ['shell:distil_game']
      bootstrap:
        files: ['js/boot.lua']
        tasks: ['shell:distil_bootstrap']
    shell:
      distil_game:
        command: 'moonshine distil -d lua lua'
      distil_bootstrap:
        command: 'moonshine distil -o js/boot.lua.json js/boot.lua'
      distil_examples:
        command: 'moonshine distil -d examples examples'
    connect:
      server:
        options:
          port: 8000

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-shell')

  grunt.registerTask 'default', ['coffee', 'shell', 'concat', 'connect:server', 'watch']
  grunt.registerTask 'compile', ['coffee', 'shell', 'concat']
