(function(exports,require){
  
  /*
   * module dependence
   */
  
   var $        = require('jQuery')
     , validate = require('validate')
     , plugin   = require('validate.plugin')
     , required = plugin.required
     , formate  = plugin.formate;

   var lang = {
     email:['email is required','plase input a valid email'],
     username : ['name is required'],
     password : ['password is required','password is not equal']
   };


   var p = $('input[type=password]');

   function equal(msg){
     var result = {
       error : true,
       msg : msg
     };
     if(p[0].value === p[1].value){
       result.error = false;
       result.msg = '';
     }
     return result;
   }



   function email(input){
     this.use(required,input,lang.email[0]);
     this.use(formate,input,lang.email[1]);
   }

   function username(input){
     this.use(required,input,lang.username[0]);
   }

   function password(input){
     this.use(required,input,lang.password[0]);
     this.use(equal,lang.password[1]);
   }

   exports.register = function(){
     var register = validate('form.register');

     $('form.register').on('submit',function(e){
       var error = register.check([
         email,
         username,
         password,
         password
       ]).error;
       
       if(error){
         e.preventDefault();
       }
     });
   };

})(window,require);
