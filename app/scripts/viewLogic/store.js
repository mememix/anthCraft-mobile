(function(exports,require){

  /*
   * module dependence
   */
  
   var slide     = require('slide')
     , location = require('location')
     , stopClick = require('stopClick');

   exports.store = function(){
     //store page slider
     slide('.page-store #slider','.page-store .menu-bar .slidable');
     //themeDetail page slider
     slide('.theme-detail #sub-slider','.theme-detail .sub-menu-bar .btn',
           function(){},
           function(){},
           true
          );

     stopClick('.page-store .diy',function(){
       location.href = '/design';
     });
   };

})(window,require);
