(function(exports){
  /*
   * module dependence
   */
  
   var $ = require('jQuery');


  function stopClick (s,cb){
    var end = 0 ,start = 0;
    var diff = 5;
    $(s).bind('touchstart',function(e){
      end = start = e.originalEvent.touches[0].clientX;
    });
    $(s).bind('touchmove',function(e){
      end = e.originalEvent.touches[0].clientX;
    });
    $(s).bind('touchend',function(e){
      if(Math.abs(end-start) > diff){
        e.preventDefault();
      }else{
        if(cb){ cb();}
      }
    });
  }
  exports.stopClick =stopClick;

})(window,require);
