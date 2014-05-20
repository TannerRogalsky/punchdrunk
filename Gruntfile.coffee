module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      app:
        options:
          join: true
        files:
          'js/love.js': [
            'coffeescript/love.js/*.coffee',
            'coffeescript/love.js/audio/*.coffee',
            'coffeescript/love.js/graphics/*.coffee',
          ]
          'js/punchdrunk.js': [
            'coffeescript/punchdrunk.coffee'
          ]
    watch:
      coffeescript:
        files: ['coffeescript/**/*.coffee', 'coffeescript/*.coffee']
        tasks: ['coffee:app']
      game:
        files: ['lua/*.lua']
        tasks: ['shell:distil_game']
      bootstrap:
        files: ['coffeescript/boot.lua']
        tasks: ['shell:distil_bootstrap']
    shell:
      distil_game:
        command: './node_modules/moonshine/bin/moonshine distil -d lua lua'
      distil_bootstrap:
        command: './node_modules/moonshine/bin/moonshine distil -o js/boot.lua.json coffeescript/boot.lua'
    connect:
      server:
        options:
          port: 8000
          base: '.'

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-connect')

  grunt.registerTask 'default', ['coffee', 'shell', 'connect:server', 'watch']
  grunt.registerTask 'compile', ['coffee', 'shell']
