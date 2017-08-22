# add_checkout_button = () ->
#   window.checkout ||= $('<span>Checkout</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
# add_account_buttons = () ->
#   window.login ||= $('<span>Login</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/login").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
#   window.register ||= $('<span>Register</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/users/new").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))

window.added_to_cart = (data) ->
  console.log(data)
  confirm("#{data['animal']['name']} was added to your cart.")

setup_animal = (id, name) ->
  console.log("Setting Up #{name} (#{id})")
  this_tag = $(".sh-animal[data-id=#{id}]")
  this_tag.text('')
  # this_tag.append($("<br>"))
  link = $('<a>Add To Cart</a>').addClass('btn').addClass('btn-default').attr('style','display: inline-block;').appendTo(this_tag)
  link.on 'click', ->
    link.attr('disabled','') #UniqueUser cookie is from HiredHands website, I am stealing it for my own uses....
    get = $.ajax({url: "https://semenhub.shop/cart/" + encodeURIComponent(Cookies.get("UniqueUser")) + "/add?animalid=#{id}", dataType: "jsonp", jsonpCallback: "window.added_to_cart"})


setup_animals = () ->
  <% @animals.each do |animal| %>
  #no indentation so coffescript does not have issues
  setup_animal(<%= animal.id %>, "<%= animal.name %>")
  <% end %>
  checkout_tag = $(".sh-checkout").text("")
  $("<a>Checkout</a>").addClass('btn').addClass('btn-default').attr('style','display: inline-block').attr("href","https://semenhub.shop/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo(checkout_tag)


$(document).ready ->
  unless typeof Cookies != 'undefined'
    console.log("Getting Cookies")
    $.ajax({url: "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.1.3/js.cookie.js", dataType: "script"}).success ->
      setup_animals()
  else
    console.log("Cookies exits")
    setup_animals()
