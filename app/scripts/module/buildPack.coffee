me = this
swap = slide('#slider','.menu-bar .btn')
select = (s,cb)->
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
      type: 'PUT'
    })
    swap.slide(1)
this.designWallpaper = wallpaper

#step 2: select iconset
iconset = ()->
  select.call this,'.icon-container .layout-container',(ele)->
    iconset = ele.data('iconset')
    $.ajax({
      url:'/design/theme/' + themeid + '/chose/iconset/' + iconset
      type: 'PUT'
    })
    swap.slide(2)
this.designIconset  = iconset

#step 3: preview package and build a package
build = ()->
  $.ajax({
    url:'/design/theme/' + themeid + '/preview'
    type: 'POST'
    dataType: 'json'
  }).done((data)->
      prefix = $('#sub-slider').data('prefix')
      preview = menu = ""
      for url in data.previewList
        preview += """
        <div class="preview-container">
             <div class="loader">
                <img class="thum" src="#{prefix}#{url}"></img>
                <img class="loading" src="/images/default.png"></img>
             </div>
        </div>
        """
        menu += """
          <a class="cy-dot-btn btn" role="button">
          </a>
        """
      $('#sub-slider .swipe-wrap').empty().html(preview)
      $('.theme-preview .sub-menu-bar').empty().html(menu)
      me.slide('#sub-slider','.sub-menu-bar .btn')
  )




this.designBuild = build

wallpaper()
iconset()
