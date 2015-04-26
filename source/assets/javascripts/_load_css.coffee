window.loadCSS = (file) ->

  callback = () ->
    link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = file
    head = document.getElementsByTagName('head')[0]
    head.appendChild(link)

  animation_frame = (
    requestAnimationFrame ||
    mozRequestAnimationFrame ||
    webkitRequestAnimationFrame ||
    msRequestAnimationFrame
  )

  if animation_frame
    animation_frame(callback)
  else
    window.addEventListener('load', callback)
