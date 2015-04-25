window.WebFontConfig =
  google:
    families: ['Martel:400,800:latin']

(() ->
  wf = document.createElement('script')
  wf.src = 'https://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'
  wf.async = true
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(wf, s)
)()
