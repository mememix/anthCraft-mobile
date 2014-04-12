(function(exports,require){

  /*
   * module dependence
   */
  
   var slide = require('slide');

   exports.store = function(){
     //store page slider
     slide('.page-store #slider','.page-store .menu-bar .btn');
     //themeDetail page slider
     slide('.theme-detail #sub-slider','.theme-detail .sub-menu-bar .btn');

   };

})(window,require);
