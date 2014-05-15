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
          'js/amore.js': [
            'coffeescript/amore.coffee'
          ]
    watch:
      coffeescript:
        files: ['coffeescript/**/*.coffee', 'coffeescript/*.coffee']
        tasks: ['coffee:app']
      moonshine:
        files: ['lua/*.lua']
        tasks: ['shell:distil']
    shell:
      distil:
        command: './node_modules/moonshine/bin/moonshine distil -d lua lua'
    connect:
      server:
        options:
          port: 8000
          base: '.'

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-connect')

  grunt.registerTask 'default', ['connect:server', 'watch']
  grunt.registerTask 'compile', ['coffee', 'shell:distil']
