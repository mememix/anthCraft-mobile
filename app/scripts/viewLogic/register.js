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


   function sendRegist(user){
       $.ajax({
         url:'/register',
         type:'POST',
         data: {
          email:user.email,
          username:user.username,
          password:user.password,
          password2:user.password2
         }
       }).done(function(data){
         if(data.code === 100){
           $('.register').hide();
           $('.register-success').show();
         }else{
           $('#msg').text(data.msg);
         }
       });
   }


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


     $('form.register').bind('submit',function(e){
       e.preventDefault();
       var form = this;
       var error = register.check([
         email,
         username,
         password,
         password
       ]).error;

       
       if(!error){
         sendRegist({
          username:form.username.value,
          email:form.email.value,
          password:form.password.value,
          password2:form.password2.value
         });
       }
     });
   };

})(window,require);
