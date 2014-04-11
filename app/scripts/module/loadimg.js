(function(exports){

  /**
   * this module only 
   * change image opacity from 0 to 1
   * if you want some animation
   * please use css3 to confige it
   */


  function onload(img){
    img.binded = true;
    img.onload = function(){
      this.style.opacity = '1';
    };
  }

  /**
   * selector [string]
   */
  exports.loadimg = function(s){
    var imglist = document.querySelectorAll(s),img;

    for (var i = 0, len = imglist.length; i < len; i++) {
      img = imglist[i];
      if(img.complete || img.binded){ continue; }
      img.style.opacity = '0';
      img.style.transition = 'opacity .5s';
      onload(img);
    }
  };

})(window);
