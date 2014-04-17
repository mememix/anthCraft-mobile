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

   var icon = $('.mask .process');

  exports.mask = {
    show:function(info){
      icon.show();
      info = info || '';
      msg.text(info);
      ele.show();
      icon.showw();
    },
    hide:function(info){
      icon.show();
      info = info || '';
      msg.text(info);
      ele.hide();
      icon.hide();
    },
    msg : function(info){
      icon.hide();
      msg.text(info);
    },
    element: ele
  };

})(window);
