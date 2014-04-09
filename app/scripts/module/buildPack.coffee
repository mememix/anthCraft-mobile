select = (s)->
  me = this
  eles = $(s)
  activeElement = $(eles[0])
  activeElement.addClass('selected')
  me.done = false
  eles.bind('click',()->
    if activeElement
      activeElement.removeClass('selected')
    $(this).addClass("selected")
    activeElement = $(this)
    me.done = true
  )

#step 1: select wallpaper 
wallpaper = (id)->
  select.call this,'.wallpaper .layout-container'
  this.next id
this.designWallpaper = wallpaper

#step 2: select iconset 
iconset = (id)->
  select.call this,'.icon-container .layout-container'
  this.next id

#step 3: preview package and build a package 
build = (id)->
  console.log id


#flow controller
Flow = ()->

Flow.prototype.push = (step)->
  this._stack = this._stack || []
  this._stack.push step

Flow.prototype.execute = ()->
  if !this._stack or !this._stack.length
    return
  this._action =  this._stack[0]
  this._stack[0].apply this,arguments

Flow.prototype.next = ()->
  index = this._stack.indexOf this._action
  this._action = this._stack[++index]
  if this._action
    this._action.apply this,arguments




#logic enternace 
bootstrap = ()->
  themeid = $('.page-package').data('themeid')
  if !themeid 
    return

  flow = new Flow()
  flow.push wallpaper
  flow.push iconset
  flow.push build
  flow.execute(themeid)

bootstrap()


