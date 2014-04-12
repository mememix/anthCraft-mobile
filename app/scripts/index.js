(function(exports,require){

  /**
   * this module is response for all commone
   * pre dom interactive logic and it's also
   * the programe enterance for all other modules
   * include both specifid business logic modules
   * and common plugins.
   */


  /*
   * module dependence
   */
  
   var route  = require('route')
     , all    = require('all')
     , login  = require('login')
     , register = require('register')
		 , design = require('design');


	 var app = route();

	 app.when('/design/theme',design);
   app.when('/login',login);
   app.when('/register',register);
	 app.any(all);

})(window,require);
