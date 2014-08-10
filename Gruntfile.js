module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    spritepacker: {      
      gamehd: {
        options: {
          // Path to the template for generating metafile:
          template: './sprites/atlas.tpl',

          // Destination metafile:
          destCss: './assets/textures/hd/game.json',
          
          baseUrl: './',
          
          powerOfTwo: true
        },
        
        files: {
          './assets/textures/hd/game.png': ['./sprites/hd/game/*.png']
        }
      },
      
      mainhd: {
        options: {
          // Path to the template for generating metafile:
          template: './sprites/atlas.tpl',

          // Destination metafile:
          destCss: './assets/textures/hd/main.json',
          
          baseUrl: './',
          
          powerOfTwo: true
        },
        
        files: {
          './assets/textures/hd/main.png': ['./sprites/hd/main/*.png']
        }
      },
      
      gamesd: {
        options: {
          // Path to the template for generating metafile:
          template: './sprites/atlas.tpl',

          // Destination metafile:
          destCss: './assets/textures/sd/game.json',
          
          baseUrl: './',
          
          powerOfTwo: true
        },
        
        files: {
          './assets/textures/sd/game.png': ['./sprites/sd/game/*.png']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-sprite-packer');

  // Default task(s).
  grunt.registerTask('pack', ['spritepacker']);
};