window.added_to_cart = (data) ->
  console.log(data)
  confirm("<%= @animal.name %> was added to your cart.")

add_checkout_button = () ->
  window.checkout ||= $('<span>Checkout</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
add_account_buttons = () ->
  window.login ||= $('<span>Login</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/login").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))
  window.register ||= $('<span>Register</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/users/new").appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))

this_tag = $('script').last() #works outside ready only... Because this is the last script tag that was loaded!
this_tag.append($("<br>"))

create_add_to_cart_button = () ->
  link = $('<a>Add To Cart</a>').addClass('btn').addClass('btn-default').attr('style','display: inline-block;').insertAfter(this_tag)
  link.on 'click', ->
    link.attr('disabled','') #UniqueUser cookie is from HiredHands website, I am stealing it for my own uses....
    get = $.ajax({url: "https://semenhub.shop/cart/" + encodeURIComponent(Cookies.get("UniqueUser")) + "/add?animalid=<%= @animal.id %>", dataType: "jsonp", jsonpCallback: "window.added_to_cart"})

# $(document).ready ->
unless typeof Cookies != 'undefined'
  console.log("Getting Cookies")
  $.ajax({url: "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.1.3/js.cookie.js", dataType: "script"}).success ->
    create_add_to_cart_button() if "<%= Setting.get_setting(:add_to_cart_buttons_enabled).value %>" == "true"
    add_checkout_button() if "<%= Setting.get_setting(:checkout_button_enabled).value %>" == "true"
    add_account_buttons() if "<%= Setting.get_setting(:remote_account_access_buttons_enabled).value %>" == "true"
else
  console.log("Cookies exits")
  create_add_to_cart_button()
  add_header_buttons()

