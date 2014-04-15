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

   var icon = $('.mask .processing');

  exports.mask = {
    show:function(info){
      icon.show();
      info = info || '';
      msg.text(info);
      ele.show();
    },
    hide:function(info){
      icon.show();
      info = info || '';
      msg.text(info);
      ele.hide();
    },
    msg : function(info){
      icon.hide();
      msg.text(info);
    },
    element: ele
  };

})(window);
