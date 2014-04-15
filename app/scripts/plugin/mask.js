(function(exports){
  /*
   * module dependence
   */
  
   var $ = require('jQuery');


   var ele = $('.mask').hide().bind('touchstart',function(e){
     e.stopPropagation();
     e.preventDefault();
   });

  exports.mask = {
    show:function(){
      ele.show();
    },
    hide:function(){
      ele.hide();
    },
    element: ele
  };

})(window);
