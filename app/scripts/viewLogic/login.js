(function(exports,require){

  /*
   * module dependence
   */

  var $        = require('jQuery')
    , validate = require('validate')
    , rules    = require('validate.plugin')
    , required = rules.required;

  var lang = {
    name:'user name is required',
    password:'password  is required'
  };

  function username(input){
    this.use(required,input,lang.name);
  }

  function password(input){
    this.use(required,input,lang.password);
  }
  exports.login = function(){
    var validator = validate('form.login');
    $('form.login').on('submit',function(e){
      var error =  validator.check([
        username,
        password
      ]).error;

      if(error){
        e.preventDefault();
      }
    });
  };

})(window,require);
