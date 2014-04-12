(function(exports,require){

  /*
   * module dependence
   */
  
	var location = require('location');

  //this route module should be abstract in to a 
  //anohter single file,it's not finished yet,but
  //can work for current project
  exports.route = function(){
    var box = {};
    return {
      when: function(href,fn){
        var reg = new RegExp(href);
        var key = null,fns;
        if(reg.test(location.href)){
          key = reg + '';
          fns = box[key] = box[key] = [];
          fns.push(fn);
          for (var i = 0, len = fns.length; i < len; i++) {
            fns[i].call(null);
          }
        }
        return this;
      },
      any: function(fn){
        var fns = box.__default__ = box.__default__ || [];
        fns.push(fn);
        for (var i = 0, len = fns.length; i < len; i++) {
          fns[i].call(null);
        }
        return this;
      }
    };
  };

})(window,require);
