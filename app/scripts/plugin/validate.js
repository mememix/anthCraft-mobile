(function(exports){

  function require(id){
    return exports[id];
  }

  /*
   * module dependence
   */
  
   var $ = require('jQuery');


  exports.validate = function(range){
    var inputs = $(range + ' input[type=text]');

    return {
      check: function(rule,opt){
        var me = this;
        inputs.each(function(i,input){
          if(!opt[i]){return;}
          var msg = opt[i],tips;
          var error = !rule(input);
          var $input = $(input);
          if(error && !me.error){
            me.error = true;
            tips = '<i class="icon-warn"></i><span class="error-tips">'+ msg.error +'</span>';
            $input.addClass('error');
            $(tips).insertAfter(input);
          }else if (!error && me.error){
            me.error = false;
            $input.removeClass('error');
            $input.siblings(':first').remove();
            $input.siblings(':first').remove();
          }
        });
        return me;
      }
    };
    
  };

})(window);
