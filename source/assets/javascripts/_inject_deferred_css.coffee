# Remove "no-js" class from <html> root element ASAP
document.documentElement.className = ''

callback = () ->
  deferred_css = document.getElementById('deferred_css')
  deferred_css.insertAdjacentHTML('afterend', deferred_css.innerText)

animation_frame = (
  this.requestAnimationFrame ||
  this.mozRequestAnimationFrame ||
  this.webkitRequestAnimationFrame ||
  this.msRequestAnimationFrame
)

if animation_frame
  animation_frame(callback)
else
  window.addEventListener('load', callback)
