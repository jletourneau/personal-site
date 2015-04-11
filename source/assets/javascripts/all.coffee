window.loadCSS = (file) ->

  callback = () ->
    link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = file
    head = document.getElementsByTagName('head')[0]
    head.parentNode.insertBefore(link, head)

  animation_frame = requestAnimationFrame || mozRequestAnimationFrame || webkitRequestAnimationFrame || msRequestAnimationFrame

  if animation_frame
    animation_frame(callback)
  else
    window.addEventListener('load', callback)

# Move requires to top if needed...
#
#= require foundation/js/vendor/modernizr
#= require foundation/js/vendor/jquery
