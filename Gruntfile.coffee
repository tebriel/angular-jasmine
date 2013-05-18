module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        connect:
            default:
                base: '.'
                keepalive: true
                port: 8000

    grunt.registerTask 'server', ['connect:default:keepalive']
    grunt.loadNpmTasks 'grunt-devtools'
    grunt.loadNpmTasks 'grunt-contrib-connect'
