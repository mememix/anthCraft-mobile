
new Swipe(document.getElementById('slider'),{
  continuous: false
  disableScroll: false
  stopPropagation: false
  callback: (index, elem)->
  transitionEnd: (index, elem)->
})
