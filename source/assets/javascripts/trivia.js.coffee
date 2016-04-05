#= require _zepto

$(document).on 'click', '.question', ->
  $(this)
    .find('.answer')
    .toggleClass('show')

# Can't do binding on $(document) here because Zepto cannot stop event
# propagation with that binding style
$('.answer').on 'click', 'a', (e) ->
  e.stopPropagation()
