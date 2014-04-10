(function(exports) {
  function upload(file, url) {
    var form = new FormData(),
    xhr = new XMLHttpRequest();

    form.append('image', file);
    xhr.open('post', url, true);
    xhr.send(form);
  }

  function onchange(input,url){
    input.onchange = function () {
      var file = input.files[0];
      upload(file,url);
    };
  }

  exports.uploadfile = function(url,s){
    if(!url){ return; }
    s = s || 'input[type=file]';
    var inputs = document.querySelectorAll(s);
    for (var i = 0, len = inputs.length; i < len; i++) {
      onchange(inputs[i],url); 
    }
  };
})(window);

