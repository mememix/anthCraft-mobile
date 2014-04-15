(function(exports,require){

  /*
   * module dependence
   */
  var $          = require('jQuery')
    , uploadfile = require('uploadfile')
    , slide      = require('slide')
    , validate   = require('validate')
    , rules      = require('validate.plugin')
    , mask       = require('mask')
    , dirty      = false
    , required   = rules.required;

  function select (s,cb) {
    var eles          = $(s)
      , activeElement = $($(s+' .layout-container')[0]);

    //the first element should be selected as the default assets
    //for build a theme pack
    activeElement.addClass('selected');

    eles.on('click','.layout-container',function(){
      if(activeElement !== $(this)){
        dirty = true;
      }
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
    uploadfile('/design/theme/' + themeid + '/upload/wallpaper',function(file,defer){
			mask.show('Uploading Wallpaper...');
			defer.done(function(){
				mask.hide();
        swap.slide(1);
			}).fail(function(){
        mask.msg('Opps,uploading failed.');
        setTimeout(function(){
          mask.hide();
        },700);
      });
    });
    //when user chooseed wallpaper,swap to next iconset view
    //and send http requrest to server
    select.call(this,'.wallpaper',function(ele){
      var wallpaperId = ele.data('wpid');
      mask.show('Setting Wallpaper ...');
      $.ajax({
        url:'/design/theme/' + themeid + '/chose/wallpaper/' + wallpaperId,
        type: 'PUT'
      }).done(function(){
        swap.slide(1);
        mask.hide();
      }).fail(function(){
        mask.msg('Opps,wallpaper setting error.');
        setTimeout(function(){
          mask.hide();
        },700);
      });
    });
  }

  /**
    * theme design page -> icon set view logic
    */
  function iconset(themeid,swap){
    select.call(this,'.icon-container',function(ele){
      var iconset = ele.data('iconset');
      mask.show('Setting icon ...');
      $.ajax({
        url:'/design/theme/' + themeid + '/chose/iconset/' + iconset,
        type: 'PUT'
      }).done(function(){
        swap.slide(2);
        mask.hide();
      }).fail(function(){
        mask.msg('Opps,icon setting  error.');
        setTimeout(function(){
          mask.hide();
        },700);
      });
    });
  }

  function buildPreview(themeid){
    if(!dirty){
      return;
    }
    $('.page-package .theme-preview .thum').hide();
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
  slide('#sub-slider','.sub-menu-bar .btn');

  exports.designBuild = buildPreview;

  function pack(themeid,swap){
    dirty = false;
    var url = '/design/theme/' +themeid +'/package';
    var element = $(this);
    packaging(element);
    $.ajax({
      url: url,
      type: 'POST',
      data:{
       themeTitle:$('#inputPassword')[0].value,
       isShare:$('#shared')[0].checked ? 1 : 0
      },
      dataType: 'json'
    }).done(function(data){
      if(data.success){
        buildSuccess(data);
      }else{
        buildFailed(data);
      }
    }).fail(function(){
      buildFailed();
    }).always(function(){
      swap.slide(3);
      packageDone(element);
    });
  }

  function packaging(ele){
    mask.show('Theme is building...');
    ele.text('Packaging...');
  }

  function packageDone(ele){
    mask.hide();
    ele.text('Package');
  }

  function buildSuccess(data){
    $('#resultPage .succeeded').show();
    $('#resultPage .failed').hide();

    var btn = $('#resultPage .succeeded .cy-btn');
    var path = btn.data('path') + data.apkFile.file;
    btn.attr('href',path);
    btn.attr('download',data.fileName + '.apk');
  }

  function buildFailed(){
    $('#resultPage .succeeded').hide();
    $('#resultPage .failed').show();
  }


  function name (input){
    this.use(required,input,'package name is required');
  }

  function packValidate(){
    return this.check([
      name
    ]);
  }

  //build pack main page logic
  exports.design = function(){
    //make all view slidable,and get themeid from div.page-package
    var  themeid = $('.page-package').data('themeid')
      ,  validator = validate('#pkinfos')
      ,  swap = slide('.page-package #slider'
            ,'.page-package .menu-bar .btn'
            ,function(index,elem){
              if($(elem).hasClass('buildpack')){
                buildPreview(themeid);
              }
            });

    wallpaper(themeid,swap);
    iconset(themeid,swap);

    var start , end ;
    $('.buildpack').bind('touchstart',function(e){ 
      end = start = e.originalEvent.touches[0].clientX;
    });
    $('.buildpack').bind('touchmove',function(e){
      end = e.originalEvent.touches[0].clientX;
      if(start > end ){
        e.stopPropagation();
      }
   });

    $('#actBuild').click(function(){
      var error = packValidate.call(validator).error;
      if(!error){
        pack.call(this,themeid,swap);
      }
    });

    $('#resultPage').on('click','.tryagain',function(){
      swap.slide(2);
    });
  };

})(window,require);
