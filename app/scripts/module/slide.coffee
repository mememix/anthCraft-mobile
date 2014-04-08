slide = (id,mu)->
	menus = document.querySelectorAll(mu)
	if menus.length is 0
		return
	activeNo = 0
	menus[activeNo].className = menus[activeNo].className.replace(' active','')
	menus[activeNo].className += ' active'
	onclick =(ele, index)->
		if ele.ontouchend is not 'undefinded'
			ele.ontouchend = ()->
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
		transitionEnd: (index, elem)->
	})

#master slider
slide('slider','.menu-bar .btn')

#sub slider
slide('sub-slider','.sub-menu-bar .btn')

