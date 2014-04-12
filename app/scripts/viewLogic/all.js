(function(exports,require){

  /*
   * module dependence
   */
   var loadimg  = require('loadimg')
     , scroll   = require('scroll');


   exports.all = function(){
     //fadein image on load
     loadimg('.thum');
		 //user click More Button 
		 //or scoll donw to the screen bottom
		 //this event listener will be treiggered
		 scroll('.scroll',function(){
			 //fadein image on load
			 loadimg('.thum');
		 });
     toTop();
   };

})(window,require);
