(function(exports){

  function require(id){
    return exports[id];
  }

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
   var loadimg  = require('loadimg')
		 , location = require('location')
     , scroll   = require('scroll')
	 //logic module
		 , design = require('design');


	 //this route module should be abstract in to a 
	 //anohter single file,it's not finished yet,but
	 //can work for current project
	 function route(){
		 var box = {};
		 return {
			 when: function(href,fn){
				 var reg = new RegExp(href);
				 var key = null,fns;
				 if(reg.test(location.href)){
					 key = reg + '';
					 fns = box[key] = box[key] = [];
					 fns.push(fn);
					 for (var i = 0, len = fns.length; i < len; i++) {
						 fns[i].call(null);
					 }
				 }
				 return this;
			 },
			 any: function(fn){
				 var fns = box.__default__ = box.__default__ || [];
				 fns.push(fn);
				 for (var i = 0, len = fns.length; i < len; i++) {
					 fns[i].call(null);
				 }
				 return this;
			 }
		 };
	 }

   function bootstrap(){
     //fadein image on load
     loadimg('.thum');
		 //user click More Button 
		 //or scoll donw to the screen bottom
		 //this event listener will be treiggered
		 scroll('.scroll',function(){
			 //fadein image on load
			 loadimg('.thum');
		 });
   }

	 var app = route();

	 app.when('/design/theme',design);
	 app.any(bootstrap);

})(window);
