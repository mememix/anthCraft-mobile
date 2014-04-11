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
   var loadimg         = require('loadimg')
     , designWallpaper = require('designWallpaper')
     , designIconset   = require('designIconset')
     , scroll          = require('scroll');


   function bootstrap(){
     designWallpaper();
     designIconset();
     //fadein image on load
     loadimg('.thum');
   }

   bootstrap();
   scroll('.scroll',function(){
     bootstrap();
   });

})(window);
