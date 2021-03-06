(function(exports,require){

  /*
   * module dependence
   */
  var Swipe     = require('Swipe')
    , $         = require('jQuery')
    , stopClick = require('stopClick');

  function touch(ele,index,swip){
    if(ele.ontouchstart !== 'undefinded'){
      $(ele).unbind('touchstart').bind('touchstart',function(){
        swip.slide(index);
      });
    }else{
      $(ele).unbind('click').bind('click',function(){
        swip.slide(index);
      });
    }
  }


  function menuLogic(mu,swip){
    var menus = $(mu);
    if(menus.length === 0){ return; }
    var activeNo = 0;
    $(menus[activeNo]).removeClass('active');
    $(menus[activeNo]).addClass('active');

    menus.each(function(index,ele){
      touch(ele,index,swip);
    });


    return function(index){
      if(index >= menus.length){
        index=menus.length-1;
      }
      $(menus[activeNo]).removeClass('active');
      $(menus[index]).addClass('active');
      activeNo = index;
    };
  }

  exports.slide = function(id,mu,cb,te,continuous){
    var swip = new Swipe(document.querySelector(id),{
      continuous: continuous || false,
      disableScroll: false,
      stopPropagation: true,
      callback: function(index, elem){
        if(cb){cb(index,elem);}
        state(index,elem);
      },
      transitionEnd: function(index, elem){
        if(te){ te(index,elem);}
      }
    });
    var state = menuLogic(mu,swip);
    stopClick('#slider a');
    return swip;
  };

})(window,require);
