(function(exports){

  /*
   * module dependence
   */
  
   var $ = require('jQuery');

  function goTop() {
    $('.layout').scroll(function() {
      //若滚动条离顶部大于100元素
      if( $(this).scrollTop()>100){
        $('#gotop').fadeIn(1000);//以1秒的间隔渐显id=gotop的元素
      }else{
        $('#gotop').fadeOut(1000);//以1秒的间隔渐隐id=gotop的元素
      }
    });
  }

  /**
   * selector [string]
   */
  exports.toTop = function() {
    //点击回到顶部的元素
    $('#gotop').click(function() {
      //以1秒的间隔返回顶部
      $('.layout').animate({scrollTop:0},1000);
    });
    $('#gotop').mouseover(function() {
      $(this).css('background-position','0 0');
    });
    $('#gotop').mouseout(function() {
      $(this).css('background-position','-76px 0');
    });
    goTop();//实现回到顶部元素的渐显与渐隐
  };

})(window);
