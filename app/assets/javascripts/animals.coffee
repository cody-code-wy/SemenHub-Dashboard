# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  getBreeds = () ->
    $('#registryinfo').empty()
    $.getJSON("/breeds").done (jd) ->
      selected_breed = (jd.filter (breed) -> breed.id == Number($('#animal_breed_id').find("option:selected").attr('value')))[0]
      for registry in selected_breed.registrars
        registrar = parameterize(registry.registrar_name)
        console.log(registry)
        $("<div></div>").attr('id', "registryinfo_#{registrar}").addClass("registry").appendTo("#registryinfo")
        wrapper = $("<div></div>").appendTo("#registryinfo_#{registrar}")
        $("<label for=\"registry_#{registrar}_registration\">#{registry.registrar_name} Registration</label>").appendTo(wrapper)
        $("<input type=\"text\" name=\"registrations[#{registrar}][registration]\" id=\"registry_#{registrar}_registration\">").appendTo(wrapper)
        wrapper = $("<div></div>").appendTo("#registryinfo_#{registrar}")
        $("<label for=\"registry_#{registrar}_ai_certification\">#{registry.registrar_name} AI Certification</label>").appendTo(wrapper)
        $("<input type=\"text\" name=\"registrations[#{registrar}][ai_certification]\" id=\"registry_#{registrar}_ai_certification\">").appendTo(wrapper)
        getRegistrations() if $('body').data('params-id')

  getRegistrations = () ->
    $.getJSON("/animals/#{$('body').data('params-id')}").done (jd) ->
      for registration in jd.registrations
        registrar = parameterize(registration.registrar_name)
        $("#registry_#{registrar}_registration").val(registration.registration)
        $("#registry_#{registrar}_ai_certification").val(registration.ai_certification)

  parameterize = (str) ->
    str.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'')

  getBreeds() if $('#animal_breed_id').length > 0

  $('#animal_breed_id').on 'change', getBreeds

  $('.add_to_order').on 'click', ->
    $.ajax('/cart/' + encodeURIComponent(Cookies.get("UniqueUser")) + "/add?animalid=" + $(this).data('animal')).success ->
      alert('Added to cart')
