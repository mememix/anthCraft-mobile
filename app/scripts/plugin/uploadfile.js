(function(exports) {

  /*
   * module dependence
   */

  var $ = require('jQuery');

  function upload(file, url) {
    var form = new FormData();
    form.append('image', file);

    return $.ajax({
      url:url,
      type: 'post',
      data:form,
      contentType:false,
      processData:false
    });
  }

  function onchange(input,url,cb){
    input.onchange = function () {
      var file = input.files[0];
      var promis = upload(file,url);
      if(cb){
        cb(file,promis);
      }
    };
  }

  exports.uploadfile = function(url,cb){
    if(!url){ return; }
    var s = 'input[type=file]';
    var inputs = document.querySelectorAll(s);
    for (var i = 0, len = inputs.length; i < len; i++) {
      onchange(inputs[i],url,cb); 
    }
  };
})(window);

