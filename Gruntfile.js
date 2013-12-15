module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    spritepacker: {
      default_options: {
        options: {
          // Path to the template for generating metafile:
          template: './sprites/hd.tpl',

          // Destination metafile:
          destCss: './assets/textures/hd/atlas.json',
          
          baseUrl: './',
          
          powerOfTwo: true
        },
        
        files: {
          './assets/textures/hd/atlas.png': ['./sprites/hd/*.png']
        },
        
        powerOfTwo: true
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-sprite-packer');

  // Default task(s).
  grunt.registerTask('default', ['spritepacker']);

};