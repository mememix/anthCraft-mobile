me = this
scrollFinish = ()->
  me.designWallpaper()
  me.designIconset()

$('.scroll').jscroll({
  autoTrigger: false
  loadingHtml: "<p class='loading'><i class='icon-spin4 animate-spin'></i>Loading more...</p>"
  callback : scrollFinish
})

