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
      type: 'PUT'
    })
this.designWallpaper = wallpaper

#step 2: select iconset 
iconset = ()->
  select.call this,'.icon-container .layout-container',(ele)->
    iconset = ele.data('iconset')
    $.ajax({
      url:'/design/theme/' + themeid + '/chose/iconset/' + iconset
      type: 'PUT'
    })
this.designIconset  = iconset

#step 3: preview package and build a package 
build = ()->
  $.ajax({
    url:'/design/theme/' + themeid + '/preview'
    type: 'POST'
  })

this.designBuild = build

wallpaper()
iconset()
