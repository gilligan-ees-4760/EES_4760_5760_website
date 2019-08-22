/* global module:false */
/* jshint node: true */
module.exports = function(grunt) {
	var port = grunt.option('port') || 8000;
	var root = grunt.option('root') || '.';
	var read = require('read-yaml');
	var path = require('path');
	var defaultStaticPath = "../../static";
	var staticPath = null;

	function build_sync_files_list() {
	  var files_list = [{
  		cwd: 'lecture_lib/assets/css/theme/',
  		src: ['*.css'],
  		dest: 'lecture_lib/library/assets/css/theme/',
  	}];
  	if (staticPath !== null) {
  	  console.log("Adding to files list...");
  	  files_list = files_list.concat([
  			{
          cwd: 'lecture_lib/library/assets',
          src: ['**/*.css'],
          dest: path.join(staticPath, 'lecture_lib/library/assets'),
        },
        {
          cwd: 'lecture_lib/library/font-awesome-4.5.0',
          src: ['**'],
          dest: path.join(staticPath, 'lecture_lib/library/font-awesome-4.5.0'),
        },
        {
          cwd: 'lecture_lib/library/reveal.js-3.7.0/plugin',
          src: ['**'],
          dest: path.join(staticPath, 'lecture_lib/library/reveal.js-3.7.0/plugin'),
        },
        {
          cwd: 'lecture_lib/library/reveal.js-3.7.0/css',
          src: ['**', '!**/*.scss'],
          dest: path.join(staticPath, 'lecture_lib/library/reveal.js-3.7.0/css'),
        },
        {
          cwd: 'lecture_lib/library/reveal.js-3.7.0/js',
          src: ['**'],
          dest: path.join(staticPath, 'lecture_lib/library/reveal.js-3.7.0/js'),
        },
        {
          cwd: 'lecture_lib/library/reveal.js-3.7.0/lib',
          src: ['**'],
          dest: path.join(staticPath, 'lecture_lib/library/reveal.js-3.7.0/lib'),
        },
        {
          cwd: 'Slides',
          src: ['**', '!**/*.yml', '!**/*.Rmd', '!**/*.md', '!**/cache/**/*',
  				      '!**/data/**/*', '!**/tmp_screenshots/**/*'],
          dest: path.join(staticPath, 'Slides'),
        }
  	  ]);
  	}
  console.log("Files list has ", files_list.length, " entries.");
  return(files_list);
  }

	try {
		var data = read.sync("gruntconfig.yml");
		if (data.hasOwnProperty("staticPath")) {
			console.log("Updating static file path from gruntconfig.yml: ",
			            data.staticPath);
			if (grunt.isDir(data.staticPath)) {
  			staticPath = data.staticPath;
			} else {
			  console.log("Read gruntconfig.yml but staticPath ",
			  data.staticPath, " does not exist.");
			}
		} else {
			console.log("Read gruntconfig.yml, but no staticPath variable.");
		}
	}
	catch (err) {
	  if (grunt.file.isDir(defaultStaticPath)) {
  	  staticPath = defaultStaticPath;
  		console.log("No gruntconfig.yml file, so using default static path ",
  		  staticPath, ".");
	  } else {
  	  console.log("No gruntconfig.yml file and default static path ",
  	    defaultStaticPath, " does not exist.");
	  }
	}


	if (!Array.isArray(root)) root = [root];

	// Project configuration
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		meta: {
			banner:
				'/*!\n' +
				' * reveal.js <%= pkg.version %> (<%= grunt.template.today("yyyy-mm-dd, HH:MM") %>)\n' +
				' * http://revealjs.com\n' +
				' * MIT licensed\n' +
				' *\n' +
				' * Copyright (C) 2018 Hakim El Hattab, http://hakim.se\n' +
				' */'
		},

		qunit: {
			files: [ 'lecture_lib/library/reveal.js-3.7.0/text/*.html' ]
		},

		uglify: {
			options: {
				banner: '<%= meta.banner %>\n',
				ie8: true
			},
			build: {
				src: 'lecture_lib/library/reveal.js-3.7.0/js/reveal.js',
				dest: 'lecture_lib/library/reveal.js-3.7.0/js/reveal.min.js'
			}
		},

		sass: {
			core: {
				src: 'lecture_lib/library/reveal.js-3.7.0/css/reveal.scss',
				dest: 'lecture_lib/library/reveal.js-3.7.0/css/reveal.css'
			},
			themes: {
				files: [
					{
						expand: true,
						cwd: 'lecture_lib/library/reveal.js-3.7.0/css/theme/source',
						src: ['*.sass', '*.scss'],
						dest: 'lecture_lib/library/reveal.js-3.7.0/css/theme',
						ext: '.css'
					},
					{
						expand: true,
						cwd: 'lecture_lib/assets/css/theme/source',
						src: ['*.scss'],
						dest: 'lecture_lib/assets/css/theme',
						ext: '.css'
					},
					{
						expand: true,
						cwd: 'lecture_lib/library/assets/css/theme/source',
						src: ['*.scss'],
						dest: 'lecture_lib/library/assets/css/theme',
						ext: '.css'
					}
				]
			}
		},

		autoprefixer: {
			core: {
				src: 'lecture_lib/library/reveal.js-3.7.0/css/reveal.css'
			}
		},

		cssmin: {
			options: {
				compatibility: 'ie9'
			},
			compress: {
				src: 'lecture_lib/library/reveal.js-3.7.0/css/reveal.css',
				dest: 'lecture_lib/library/reveal.js-3.7.0/css/reveal.min.css'
			}
		},

		jshint: {
			options: {
				curly: false,
				eqeqeq: true,
				immed: true,
				esnext: true,
				latedef: 'nofunc',
				newcap: true,
				noarg: true,
				sub: true,
				undef: true,
				eqnull: true,
				browser: true,
				expr: true,
				loopfunc: true,
				globals: {
					head: false,
					module: false,
					console: false,
					unescape: false,
					define: false,
					exports: false
				}
			},
			files: [ 'Gruntfile.js', 'lecture_lib/library/reveal.js-3.7.0/js/reveal.js' ]
		},

		connect: {
		  regular: {
  			server: {
  				options: {
  					port: port,
  					base: root,
  					livereload: true,
  					hostname: 'localhost',
  					open: true,
  					useAvailablePort: true
  				}
			  }
		  },
		  decktape: {
		    server: {
  			  options: {
  			    port: port,
  			    base: root,
  			    livereload: false,
  			    keepalive: true,
  			    hostname: 'localhost',
  			    useAvailablePort: true
  			  }
  			}
		  }
		},

		sync: {
			main: {
  				files: build_sync_files_list()
			}
		},

		watch: {
			sync: {
				files: [ 'lecture_lib/**', 'Slides/**'],
				tasks: 'sync'
			},
			js: {
				files: [
					'Gruntfile.js',
					'lecture_lib/library/reveal.js-3.7.0/js/reveal.js'
				],
				tasks: 'js'
			},
			theme: {
				files: [
					'lecture_lib/library/reveal.js-3.7.0/css/theme/source/*.sass',
					'lecture_lib/library/reveal.js-3.7.0/css/theme/source/*.scss',
					'lecture_lib/library/reveal.js-3.7.0/css/theme/template/*.sass',
					'lecture_lib/library/reveal.js-3.7.0/css/theme/template/*.scss',
					'lecture_lib/assets/css/theme/**/*.sccs',
					'lecture_lib/assets/css/theme/**/*.sass',
				],
				tasks: 'css-themes'
			},
			css: {
				files: [ 'lecture_lib/library/reveal.js-3.7.0/css/reveal.scss' ],
				tasks: 'css-core'
			},
			html: {
				files: root.map(path => path + '/*.html')
			},
			markdown: {
				files: root.map(path => path + '/*.md')
			},
			options: {
				livereload: true
			}
		},

		retire: {
			js: [
				'lecture_lib/library/reveal.js-3.7.0/js/reveal.js',
				'lecture_lib/library/reveal.js-3.7.0/lib/js/*.js',
				'lecture_lib/library/reveal.js-3.7.0/plugin/**/*.js'
				],
			node: [ '.' ]
		}

	});

	// Dependencies
	grunt.loadNpmTasks( 'grunt-contrib-connect' );
	grunt.loadNpmTasks( 'grunt-contrib-cssmin' );
	grunt.loadNpmTasks( 'grunt-contrib-jshint' );
	grunt.loadNpmTasks( 'grunt-contrib-qunit' );
	grunt.loadNpmTasks( 'grunt-contrib-uglify' );
	grunt.loadNpmTasks( 'grunt-contrib-watch' );
	grunt.loadNpmTasks( 'grunt-autoprefixer' );
	grunt.loadNpmTasks( 'grunt-retire' );
	grunt.loadNpmTasks( 'grunt-sass' );
	grunt.loadNpmTasks( 'grunt-sync' );
	grunt.loadNpmTasks( 'grunt-zip' );

	// Default task
	grunt.registerTask( 'default', [ 'css', 'js', 'sync' ] );

	// JS task
	grunt.registerTask( 'js', [ 'jshint', 'uglify', 'qunit' ] );

	// Theme CSS
	grunt.registerTask( 'css-themes', [ 'sass:themes' ] );

	// Core framework CSS
	grunt.registerTask( 'css-core', [ 'sass:core', 'autoprefixer', 'cssmin' ] );

	// All CSS
	grunt.registerTask( 'css', [ 'sass', 'autoprefixer', 'cssmin' ] );

	// Package presentation to archive
	grunt.registerTask( 'package', [ 'default', 'zip' ] );

	// Serve presentation locally
	grunt.registerTask( 'serve', [ 'connect:regular', 'watch', 'sync' ] );


	// Serve presentation for local decktape
	grunt.registerTask( 'decktape', [ 'connect:decktape:keepalive' ] );

	// Run tests
	grunt.registerTask( 'test', [ 'jshint', 'qunit' ] );

};
