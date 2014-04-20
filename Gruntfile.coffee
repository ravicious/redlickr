fs = require 'fs'
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    notify:
      browserify:
        options:
          title: "Browserify"
          message: "Package built."
      uglify:
        options:
          title: "Uglify"
          message: "Package minified."

    watch:
      coffee:
        files: ['react_app/*.coffee']
        tasks: ['browserify', 'notify:browserify', 'uglify', 'notify:uglify']

    nodemon:
      main:
        script: './app.coffee'
        options:
          ext: 'coffee'
          ignore: ['node_modules/**', 'public/**']
          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour

            nodemon.on 'restart', () ->
              writeRebootedFile = () ->
                fs.writeFileSync('.rebooted', 'rebooted')
              setTimeout writeRebootedFile, 1000

    concurrent:
      main:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

    browserify:
      dist:
        src: ['react_app/*.js', 'react_app/*.coffee']
        dest: 'public/<%= pkg.name %>.js'
        options:
          transform: ['coffeeify']

    uglify:
      dist:
        files:
          'public/<%= pkg.name %>.min.js': ['<%= browserify.dist.dest %>']
      options:
        report: 'min'
  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'build', ['browserify', 'uglify']
  grunt.registerTask 'default', ['build', 'concurrent']
