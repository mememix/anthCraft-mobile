(function(exports){

  function require(id){
    return exports[id];
  }

  /*
   * module dependence
   */
  var $          = require('jQuery')
    , uploadfile = require('uploadfile')
    , slide      = require('slide');

  function select (s,cb) {
    var eles          = $(s)
      , activeElement = $($(s+' .layout-container')[0]);

    //the first element should be selected as the default assets
    //for build a theme pack
    activeElement.addClass('selected');

    eles.on('click','.layout-container',function(){
      if(activeElement){
        activeElement.removeClass('selected');
      }
      activeElement = $(this);
      activeElement.addClass('selected');
      cb(activeElement);
    });
  }


  /**
    * theme design page -> icon set view logic
    */
  function wallpaper(themeid,swap){
    //upload wallpaper on user choosed image
    uploadfile('/design/theme/' + themeid + '/upload/wallpaper');
    //when user chooseed wallpaper,swap to next iconset view
    //and send http requrest to server
    select.call(this,'.wallpaper',function(ele){
      var wallpaperId = ele.data('wpid');
      $.ajax({
        url:'/design/theme/' + themeid + '/chose/wallpaper/' + wallpaperId,
        type: 'PUT'
      });
      swap.slide(1);
    });
  }

  /**
    * theme design page -> icon set view logic
    */
  function iconset(themeid,swap){
    select.call(this,'.icon-container',function(ele){
      var iconset = ele.data('iconset');
      $.ajax({
        url:'/design/theme/' + themeid + '/chose/iconset/' + iconset,
        type: 'PUT'
      });
      swap.slide(2);
    });
  }

  function buildPreview(themeid){
    $.ajax({
      url:'/design/theme/' + themeid + '/preview',
      type: 'POST',
      dataType: 'json'
    }).done(function(data){
      var prefix = $('#sub-slider').data('prefix');
      var preview ='',menu = '';

      for (var i = 0, len = data.previewList.length; i < len; i++) {
        var url = data.previewList[i];
        preview += 
          '<div class="preview-container">' +
          '<div class="loader">'+
          '<img class="thum" src="' + prefix + url +'"></img>' +
          '<img class="loading" src="/images/default.png"></img>' +
          '</div>' +
          '</div>';

        menu += '<a class="cy-dot-btn btn" role="button"></a>';
      }
      $('#sub-slider .swipe-wrap').empty().html(preview);
      $('.theme-preview .sub-menu-bar').empty().html(menu);
      slide('#sub-slider','.sub-menu-bar .btn');
    });
  }
  exports.designBuild = buildPreview;

  function pack(themeid,swap){
    var url = '/design/theme/' +themeid +'/package';
    $.ajax({
      url: url,
      type: 'POST',
      data:{
       themeTitle:$('#inputPassword')[0].value,
       isShare:$('#shared')[0].checked
      },
      dataType: 'html'
    }).done(function(dom){
      $('#resultPage').empty().html(dom);
      swap.slide(3);
    });

    $('#resultPage').on('click','.tryagain',function(){
      swap.slide(2);
    });
  }

  //build pack main page logic
  exports.buildPack = function(){
    //make all view slidable,and get themeid from div.page-package
    var swap    = slide('.page-package #slider','.page-package .menu-bar .btn')
      , themeid = $('.page-package').data('themeid');

    wallpaper(themeid,swap);
    iconset(themeid,swap);

    $('#actBuild').click(function(){
      pack(themeid,swap);
    });
  };

})(window);
