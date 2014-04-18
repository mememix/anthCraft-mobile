(function(exports){
  /*
   * module dependence
   */
  
   var $ = require('jQuery');


   var ele = $('.mask').hide().bind('touchstart',function(e){
     e.stopPropagation();
     e.preventDefault();
   });

   var msg = $('.mask .msg');


  exports.mask = {
    show:function(info){
      info = info || '';
      msg.text(info);
      ele.show();
    },
    hide:function(info){
      info = info || '';
      msg.text(info);
      ele.hide();
    },
    msg : function(info){
      msg.text(info);
    },
    element: ele
  };

})(window);
