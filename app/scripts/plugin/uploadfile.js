(function(exports) {
  function upload(file, url) {
    var form = new FormData(),
    xhr = new XMLHttpRequest();

    form.append('image', file);
    xhr.open('post', url, true);
    xhr.send(form);
  }

  function onchange(input,url,cb){
    input.onchange = function () {
      var file = input.files[0];
      upload(file,url);
      if(cb){
        cb(file);
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

