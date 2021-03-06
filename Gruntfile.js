// Generated on 2014-04-01 using generator-mobile 1.0.0-alpha.1
'use strict';
var LIVERELOAD_PORT = 35729;
var lrSnippet = require('connect-livereload')({port: LIVERELOAD_PORT});
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,**/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {
    // show elapsed time at the end
    require('time-grunt')(grunt);
    // load all grunt tasks
    require('load-grunt-tasks')(grunt);

    // configurable paths
    var yeomanConfig = {
        app: 'app',
        dist: 'dist',
        views: 'views'
    };

    grunt.initConfig({
        yeoman: yeomanConfig,

        notify_hooks: {
            options: {
                enabled: true,
                max_jshint_notifications: 5, // maximum number of notifications from jshint output
                title: "AnthCraft Mobile" // defaults to the name in package.json, or will use project directory's name
            }
        },

        // TODO: Make this conditional
        watch: {
            express: {
                files: ['server/{,**/}*.{js,coffee}'],
                tasks: ['express:dev'],
                options: {
                    livereload: true,
                    nospawn: true //Without this option specified express won't be reloaded
                }
            },
            coffee: {
                files: ['<%= yeoman.app %>/scripts/{,**/}*.coffee'],
                tasks: ['coffee:dist']
            },
            coffeeTest: {
                files: ['test/spec/{,**/}*.coffee'],
                tasks: ['coffee:test']
            },
            compass: {
                files: ['<%= yeoman.app %>/styles/{,**/}*.{scss,sass}'],
                tasks: ['compass:server']
            },
            less: {
                files: ['<%= yeoman.app %>/styles/{,**/}*.less'],
                tasks: ['less:server']
            },
            livereload: {
                options: {
                    livereload: LIVERELOAD_PORT
                },
                files: [
                    '<%= yeoman.app %>/{,**/}*.html',
                    'views/{,**/}*.ejs',
                    '{.tmp,<%= yeoman.app %>}/styles/{,**/}*.css',
                    '{.tmp,<%= yeoman.app %>}/scripts/{,**/}*.js',
                    '<%= yeoman.app %>/images/{,**/}*.{png,jpg,jpeg,gif,webp,svg}'
                ]
            }
        },
        autoshot: {
            dist: {
                options: {
                    path: '/screenshots/',
                    remote : {
                        files: [
                            { src: 'http://localhost:<%= express.options.port %>', dest: 'app.jpg'}
                        ]
                    },
                    viewport: ['320x480','480x320','384x640','640x384','602x963','963x602','600x960','960x600','800x1280','1280x800','768x1024','1024x768']
                }
            }
        },

        responsive_images: {
            dev: {
                options: {
                    sizes: [
                        {
                            width: 320,
                        },
                        {
                            width: 640
                        },
                        {
                            width: 1024
                        }
                    ]
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/images',
                    src: '{,**/}*.{png,jpg,jpeg}',
                    dest: '<%= yeoman.dist %>/public/images'
                }]
            }
        },
        connect: {
            options: {
                port: 9527,
                // change this to '0.0.0.0' to access the server from outside
                hostname: '0.0.0.0'
            },
            livereload: {
                options: {
                    middleware: function (connect) {
                        return [
                            lrSnippet,
                            mountFolder(connect, '.tmp'),
                            mountFolder(connect, yeomanConfig.app)
                        ];
                    }
                }
            },
            test: {
                options: {
                    middleware: function (connect) {
                        return [
                            mountFolder(connect, '.tmp'),
                            mountFolder(connect, 'test')
                        ];
                    }
                }
            },
            dist: {
                options: {
                    middleware: function (connect) {
                        return [
                            mountFolder(connect, yeomanConfig.dist)
                        ];
                    }
                }
            }
        },

        express: {
            options: {
                // Override defaults here
                // cmd: 'coffee',
                port: 9527
            },
            dev: {
                options: {
                    script: 'launch.js'
                }
            },
            dist: {
                options: {
                    script: 'launch.js',
                    node_env: 'production'
                }
            },
            test: {
                options: {
                    script: 'launch.js'
                }
            }
        },
        open: {
            server: {
                path: 'http://localhost:<%= express.options.port %>'
            }

            ,
            nexus4:{
                path: 'http://www.browserstack.com/start#os=android&os_version=4.2&device=LG+Nexus+4&speed=1&start=true&url=http://rnikitin.github.io/examples/jumbotron/'
            },
            nexus7:{
                path: 'http://www.browserstack.com/start#os=android&os_version=4.1&device=Google+Nexus+7&speed=1&start=true&url=http://rnikitin.github.io/examples/jumbotron/'
            },
            iphone5:{
                path: 'http://www.browserstack.com/start#os=ios&os_version=6.0&device=iPhone+5&speed=1&start=true&url=http://localhost:9000/'
            }

        },
        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '.tmp',
                        '<%= yeoman.dist %>/*',
                        '!<%= yeoman.dist %>/.git*'
                    ]
                }]
            },
            server: '.tmp'
        },
        browser_sync: {
            dev: {
                bsFiles: {
                    src : '<%= yeoman.app %>/styles/style.css'
                },
                options: {
                    watchTask: false,
                    debugInfo: true,
                    // Change to 0.0.0.0 to access externally
                    host: 'http://localhost:<%= express.options.port %>',
                    server: {
                        baseDir: '<%= yeoman.app %>'
                    },
                    ghostMode: {
                        clicks: true,
                        scroll: true,
                        links: true,
                        forms: true
                    }
                }
            }
        },
        jshint: {
            options: {
                jshintrc: '.jshintrc',
                reporter: require('jshint-stylish')
            },
            all: [
                '<%= yeoman.app %>/scripts/{,**/}*.js',
                '!<%= yeoman.app %>/scripts/vendor/*',
                'test/spec/{,**/}*.js'
            ]
        },
        mocha: {
            all: {
                options: {
                    run: true,
                    urls: ['http://localhost:<%= express.options.port %>/index.html']
                }
            }
        },
        coffee: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/scripts',
                    src: '{,**/}*.coffee',
                    dest: '.tmp/scripts',
                    ext: '.js'
                }]
            },
            test: {
                files: [{
                    expand: true,
                    cwd: 'test/spec',
                    src: '{,**/}*.coffee',
                    dest: '.tmp/spec',
                    ext: '.js'
                }]
            }
        },
        compass: {
            options: {
                sassDir: '<%= yeoman.app %>/styles',
                cssDir: '.tmp/styles',
                generatedImagesDir: '.tmp/images/generated',
                imagesDir: '<%= yeoman.app %>/images',
                javascriptsDir: '<%= yeoman.app %>/scripts',
                /*fontsDir: '<%= yeoman.app %>/styles/fonts',*/
                importPath: '<%= yeoman.app %>/bower_components',
                httpImagesPath: '/images',
                httpGeneratedImagesPath: '/images/generated',
                httpFontsPath: '/styles/fonts',
                relativeAssets: false
            },
            dist: {},
            server: {
                options: {
                    debugInfo: true
                }
            }
        },
        less: {
            dist: {
                options: {
                    compress: true,
                    cleancss: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/styles',
                    src: '{,**/}*.less',
                    dest: '.tmp/styles',
                    ext: '.css'
                }]
            },
            server: {
                options: {
                    dumpLineNumbers: true,
                    sourceMap: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/styles',
                    src: '{,**/}*.less',
                    dest: '.tmp/styles',
                    ext: '.css'
                }]
            }
        },
        // not used since Uglify task does concat,
        // but still available if needed
        /*concat: {
            dist: {}
        },*/
        requirejs: {
            dist: {
                // Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
                options: {
                    // `name` and `out` is set by grunt-usemin
                    baseUrl: yeomanConfig.app + '/scripts',
                    optimize: 'none',
                    // TODO: Figure out how to make sourcemaps work with grunt-usemin
                    // https://github.com/yeoman/grunt-usemin/issues/30
                    //generateSourceMaps: true,
                    // required to support SourceMaps
                    // http://requirejs.org/docs/errors.html#sourcemapcomments
                    preserveLicenseComments: false,
                    useStrict: true,
                    wrap: true
                    //uglify2: {} // https://github.com/mishoo/UglifyJS2
                }
            }
        },
        rev: {
            dist: {
                files: {
                    src: [
                        '<%= yeoman.dist %>/public/scripts/{,**/}*.js',
                        '<%= yeoman.dist %>/public/styles/{,**/}*.css',
                        '<%= yeoman.dist %>/public/images/{,**/}*.{png,jpg,jpeg,gif,webp}',
                        '<%= yeoman.dist %>/public/styles/fonts/*'
                    ]
                }
            }
        },


        modernizr: {

            // Path to the build you're using for development.
            "devFile" : "<%= yeoman.app %>/bower_components/modernizr/modernizr.js",

            // Path to save out the built file.
            "outputFile" : "<%= yeoman.dist %>/public/scripts/modernizr.js",

            // Based on default settings on http://modernizr.com/download/
            "extra" : {
                "shiv" : true,
                "printshiv" : false,
                "load" : true,
                "mq" : false,
                "cssclasses" : true
            },

            // Based on default settings on http://modernizr.com/download/
            "extensibility" : {
                "addtest" : false,
                "prefixed" : false,
                "teststyles" : false,
                "testprops" : false,
                "testallprops" : false,
                "hasevents" : false,
                "prefixes" : false,
                "domprefixes" : false
            },

            // By default, source is uglified before saving
            "uglify" : true,

            // Define any tests you want to impliticly include.
            "tests" : [],

            // By default, this task will crawl your project for references to Modernizr tests.
            // Set to false to disable.
            "parseFiles" : true,

            // When parseFiles = true, this task will crawl all *.js, *.css, *.scss files, except files that are in node_modules/.
            // You can override this by defining a "files" array below.
            // "files" : [],

            // When parseFiles = true, matchCommunityTests = true will attempt to
            // match user-contributed tests.
            "matchCommunityTests" : false,

            // Have custom Modernizr tests? Add paths to their location here.
            "customTests" : []
        },

        useminPrepare: {
            options: {
                dest: '<%= yeoman.dist %>/public'
            },
            html: [
                '<%= yeoman.views %>/index.ejs',
                '<%= yeoman.views %>/partials/pageFoot.ejs',
                '<%= yeoman.views %>/partials/pageHead.ejs'
            ]
        },
        usemin: {
            options: {
                dirs: [
                    '<%= yeoman.dist %>/public'
                ]
            },
            html: [
                '<%= yeoman.dist %>/views/{,**/}*.ejs'
            ],
            css: [
                '<%= yeoman.dist %>/public/styles/{,**/}*.css'
            ]
        },
        imagemin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/images',
                    src: '{,**/}*.{png,jpg,jpeg}',
                    dest: '<%= yeoman.dist %>/public/images'
                }]
            }
        },
        svgmin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/images',
                    src: '{,**/}*.svg',
                    dest: '<%= yeoman.dist %>/public/images'
                }]
            }
        },
        cssmin: {
            dist: {
                files: {
                    '<%= yeoman.dist %>/public/styles/main.css': [
                        '.tmp/styles/{,**/}*.css',
                        '<%= yeoman.app %>/styles/{,**/}*.css'
                    ]
                }
            }
        },
        htmlmin: {
            dist: {
                options: {
                    /*removeCommentsFromCDATA: true,
                    // https://github.com/yeoman/grunt-usemin/issues/44
                    //collapseWhitespace: true,
                    collapseBooleanAttributes: true,
                    removeAttributeQuotes: true,
                    removeRedundantAttributes: true,
                    useShortDoctype: true,
                    removeEmptyAttributes: true,
                    removeOptionalTags: true*/
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>',
                    src: '*.html',
                    dest: '<%= yeoman.dist %>/public'
                }]
            }
        },
        // Put files not handled in other tasks here
        copy: {
            dist: {
                files: [{
                    expand: true,
                    dot: true,
                    cwd: '<%= yeoman.app %>',
                    dest: '<%= yeoman.dist %>/public',
                    src: [
                        '*.{ico,png,txt}',
                        '.htaccess',
                        'images/{,**/}*.{webp,gif}',
                        // 'scripts/{,**/}*.js',
                        // 'styles/vendor/{,**/}*',
                        'styles/webicon/{,**/}*',
                        'styles/welcome.jpg'
                    ]
                }, {
                    expand: true,
                    cwd: '.tmp/images',
                    dest: '<%= yeoman.dist %>/public/images',
                    src: [
                        'generated/*'
                    ]
                }, {
                    expand: true,
                    cwd: '.tmp/scripts',
                    dest: '<%= yeoman.dist %>/public/scripts',
                    src: [
                        '{,**/}*'
                    ]
                }, {
                    expand: true,
                    cwd: '.',
                    dest: '<%= yeoman.dist %>',
                    src: [
                        'launch.js',
                        'package.json',
                        'bower.json',
                        'configs/**',
                        'server/**',
                        'views/**',
                        'logs/.gitkeep'
                    ]
                }]
            }
        },
        concurrent: {
            server: [
                'coffee:dist',
                // 'compass:server'
                'less:server'
            ],
            test: [
                'coffee',
                // 'compass'
                'less'
            ],
            dist: [
                'coffee',
                // 'compass:dist',
                'less:dist',
                'imagemin',
                // 'svgmin',
                'htmlmin'
            ]
        },
        bower: {
            options: {
                exclude: ['modernizr']
            },
            all: {
                rjsConfig: '<%= yeoman.app %>/scripts/main.js'
            }
        }
    });

    grunt.task.run('notify_hooks');

    grunt.registerTask('server', function (target) {
        grunt.log.warn('The `server` task has been deprecated. Use `grunt serve` to start a server.');
        grunt.task.run(['serve:' + target]);
    });

    grunt.registerTask('serve', function (target) {
        if (target === 'dist') {
            return grunt.task.run(['build', 'open', 'express:dist:keepalive']);
        }

        grunt.task.run([
            'clean:server',
            'concurrent:server',
            'express:dev',
            'open:server',
            'watch'
        ]);
    });

    grunt.registerTask('test', [
        'clean:server',
        'concurrent:test',
        'express:test',
        'mocha'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'useminPrepare',
        'concurrent:dist',
        // 'requirejs',
        // 'cssmin',
        // 'responsive_images:dev',
        'concat',
        'uglify',
        'copy',
        'rev',
        'usemin'
    ]);

    grunt.registerTask('default', [
        'jshint',
        'test',
        'build'
    ]);

    grunt.registerTask('screenshots', [
        'clean:server',
        'concurrent:server',
        'express:dev',
        'autoshot'
    ]);

};
