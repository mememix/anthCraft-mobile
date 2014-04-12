(function(exports,require){

  /*
   * module dependence
   */
  
   var $ = require('jQuery');

   function step(){
     return {
       use:function(rule,input,msg){
         if(!this.error){
           var res = rule(input,msg);
           this.error = res.error;
           this.msg   = res.msg;
         }
       }
     };
   }

   function required(input,msg){
     var result = {
       error : true,
       msg : ''
     };
     if(!input.value){
       result.error = true;
       result.msg = msg;
     }else{
       result.error = false;
     }
     return result;
   }

   function formate(input,msg){
     var result = {
       error : true,
       msg : ''
     }, reg = /.*@.*\..*/;
     if(input.value.match(reg)){
       result.error = false;
       result.msg = '';
     }else{
       result.error = true;
       result.msg = msg;
     }
     return result;
   }

  exports.validate = function (range){
    var inputs = $(range).find(' input[type=text],[type=password],[type=email]');
    $(range).addClass('validate');

    return {
      check: function(rules){
        var me = this;
        me.error = false;
        inputs.each(function(i,input){
          var $input = $(input),tips;
          if(!rules[i]){return;}
          var rule = rules[i];
          var st = step();
          rule.call(st,input);
          if(st.error){
            me.error = true;

            if(!input._iserrored){//firt time add error class
              tips = '<i class="icon-warn"></i><span class="error-tips">'+ st.msg +'</span>';
              $input.addClass('error');
              $(tips).insertAfter(input);
            }else{
              $input.siblings('.error-tips').html(st.msg);
            }
            input._iserrored = true;
          }else{
            if(input._iserrored){
              $input.removeClass('error');
              $input.next('.icon-warn').remove();
              $input.next('.error-tips').remove();
            }
            input._iserrored = false;
          }
        });
        return me;
      }
    };

  };
  
  exports['validate.plugin'] = {
    formate: formate,
    required: required
  };

})(window,require);
