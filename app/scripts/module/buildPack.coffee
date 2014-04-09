select = (s,cb)->
  me = this
  eles = $(s)
  activeElement = $(eles[0])
  activeElement.addClass('selected')
  me.done = false
  eles.bind('click',()->
    if activeElement
      activeElement.removeClass('selected')
    activeElement = $(this)
    activeElement.addClass("selected")
    me.done = true
    cb(activeElement)
  )

themeid = $('.page-package').data('themeid')

#step 1: select wallpaper 
wallpaper = ()->
  select.call this,'.wallpaper .layout-container',(ele)->
    wpId = ele.data('wpid')
    $.ajax({
      url:'/design/theme/' + themeid + '/chose/wallpaper/' + wpId
      type: 'POST'
    })
this.designWallpaper = wallpaper

#step 2: select iconset 
iconset = ()->
  select.call this,'.icon-container .layout-container',(ele)->
    iconset = ele.data('iconset')
    $.ajax({
      url:'/design/theme/' + themeid + '/chose/iconset/' + iconset
      type: 'POST'
    })
this.designIconset  = iconset

#step 3: preview package and build a package 
build = ()->
  $.ajax({
    url:'/design/theme/' + themeid + '/preview'
    type: 'POST'
  }).done((data)->
      prefix = $('#sub-slider').data('prefix')
      for url in data.previewList
        preview += """
        <div class="preview-container">
             <div class="loader">
                <img class="thum" src="#{prefix}#{url}"></img>
                <img class="loading" src="/images/default.png"></img>
             </div>
        </div>
        """
      $('#sub-slider .swipe-wrap').empty().html(preview)
  )




this.designBuild = build

wallpaper()
iconset()
