
menus = document.querySelectorAll('.menu-bar .btn')
activeNo = 0

swip = new Swipe(document.getElementById('slider'),{
  continuous: false
  disableScroll: false
  stopPropagation: false
  callback: (index, elem)->
		 menus[activeNo].className = 
			 menus[activeNo].className.replace(' active','')
		 menus[index].className += ' active' 
		 activeNo = index
  transitionEnd: (index, elem)->
})


onclick =(ele, index)->
	 if ele.ontouchend is not 'undefinded'
		 ele.ontouchend = ()->
			 swip.slide(index)
	 else
		 ele.onclick = ()->
			 swip.slide(index)

onclick menu,index for menu,index in menus
