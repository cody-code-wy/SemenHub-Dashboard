$(document).on 'turbolinks:load', ->
  $(document).trigger("#{$('body').data('params-controller')}:#{$('body').data('params-action')}")
