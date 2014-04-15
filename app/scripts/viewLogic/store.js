(function(exports,require){

  /*
   * module dependence
   */
  
   var slide     = require('slide')
     , $         = require('jQuery')
     , location  = require('location')
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
     themeDetail();
   };

   function themeDetail(){
     $('.theme-detail .info-bar').hide();
     $('.theme-detail .theme-preview').style('-webkit-transform', 'scale3d(1.5,1.5,0)');
   }

   exports.scale = themeDetail;

})(window,require);
