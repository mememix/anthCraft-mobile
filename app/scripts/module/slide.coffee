me = this
slide = (id,mu)->
  menus = document.querySelectorAll(mu)
  if menus.length is 0
    return
  activeNo = 0
  menus[activeNo].className = menus[activeNo].className.replace(' active','')
  menus[activeNo].className += ' active'
  onclick =(ele, index)->
    if ele.ontouchend is not 'undefinded'
      ele.ontouchstart = ()->
        swip.slide(index)
    else
      ele.onclick = ()->
        swip.slide(index)

  onclick menu,index for menu,index in menus

  swip = new Swipe(document.getElementById(id),{
    continuous: false
    disableScroll: false
    stopPropagation: true
    callback: (index, elem)->
      menus[activeNo].className = menus[activeNo].className.replace(' active','')
      menus[index].className += ' active' 
      activeNo = index
      if $(elem).hasClass('buildpack')
        me.designBuild()
    transitionEnd: (index, elem)->
  })

#master slider
slide('slider','.menu-bar .btn')

#sub slider
slide('sub-slider','.sub-menu-bar .btn')

me.slide = slide


#prevent default on tag <a href=""></a>
stopClick = (s,d)->
  end = start = 0;
  diff = d || 5 

  $(s).bind('touchstart',(e)->
    end = start = e.originalEvent.touches[0].clientX
  )

  $(s).bind('touchmove',(e)->
    end = e.originalEvent.touches[0].clientX
  )

  $(s).bind('touchend',(e)->
    if Math.abs(end-start) > diff
      e.preventDefault()
  )
stopClick('#slider a')
this.stopClick = stopClick
