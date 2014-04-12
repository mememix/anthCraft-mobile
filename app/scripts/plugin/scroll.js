(function(exports,require){

  /*
   * module dependence
   */
  var $ = require('jQuery');


  exports.scroll = function(s,cb){
    $(s).jscroll({
      autoTrigger: false,
      loadingHtml: '<p class="loading"><i class="icon-spin4 animate-spin"></i>Loading more...</p>',
      callback:cb
    });
  };

})(window,require);
