if <%= Rails.env.development? %>
  rooturl = 'http://localhost:3000'
else
  rooturl = 'https://semenhub.shop'

$.urlParam = (name) =>
    results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href)
    if (results==null)
       return null
    else
       return decodeURI(results[1]) || 0

# add_checkout_button = () ->
#   window.checkout ||= $('<span>Checkout</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
# add_account_buttons = () ->
#   window.login ||= $('<span>Login</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/login").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
#   window.register ||= $('<span>Register</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/users/new").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))

window.added_to_cart = (data) ->
  console.log(data)
  confirm("#{data['animal']['name']} was added to your cart.")

setup_animal = (id, name) ->
  # console.log("Setting Up #{name} (#{id})")
  this_tag = $(".sh-animal[data-id=#{id}]")
  this_tag.text('')
  # this_tag.append($("<br>"))
  link = $('<a>Add To Cart</a>').addClass('btn').addClass('btn-default').attr('style','display: inline-block;').appendTo(this_tag)
  link.on 'click', ->
    link.attr('disabled','') #UniqueUser cookie is from HiredHands website, I am stealing it for my own uses....
    get = $.ajax({url: "#{rooturl}/cart/" + encodeURIComponent(Cookies.get("UniqueUser")) + "/add?animalid=#{id}", dataType: "jsonp", jsonpCallback: "window.added_to_cart"})


setup_animals = () ->
  <% @animals.each do |animal| %>
  #no indentation so coffescript does not have issues
  setup_animal(<%= animal.id %>, "<%= animal.name %>")
  <% end %>
  checkout_tag = $(".sh-checkout").text("")
  $("<a>Checkout</a>").addClass('btn').addClass('btn-default').attr('style','display: inline-block').attr("href","#{rooturl}/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo(checkout_tag)

hide_menu = () ->
  $('#smhcnf').parent().parent().hide() #Hide Menu Element

animal_override = () ->
  if $.urlParam('AnimalID')
    console.log("Animal Detected..")
    $('#amsweb_pagemodule_AnimalDetail_tRowOtherSite').hide()
    $('.fieldLabel:contains("Owner Name:")').parent().parent().parent().hide()
    $('.fieldLabel:contains("Breeder:")').parent().parent().parent().hide()
    notes = $('.fieldLabel:contains("Notes:")').parent().parent().parent().find('.animal-detail-comments')
    old_notes = notes.text()
    notes.text("Loading from server...")
    desc = $('.fieldLabel .t-col-inner:contains("Description:")').parent().parent().find('.t-col-inner').last()
    old_desc = desc.text()
    desc.text("Loading from server...")
    $.ajax({url: "#{rooturl}/animals/#{$('.sh-animal').data('id')}/repl", dataType: "jsonp"}).done (data) ->
      if data.notes
        notes.text(data.notes)
      else
        notes.text(old_notes)

      if data.description
        desc.text(data.description)
      else
        desc.text(old_desc)

$(document).ready ->
  hide_menu()
  animal_override()
  unless typeof Cookies != 'undefined'
    console.log("Getting Cookies")
    $.ajax({url: "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.1.3/js.cookie.js", dataType: "script"}).success ->
      setup_animals()
  else
    console.log("Cookies exits")
    setup_animals()
