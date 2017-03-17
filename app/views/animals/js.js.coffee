window.added_to_cart = (data) ->
  console.log(data)
  confirm("<%= @animal.name %> was added to your cart.")

$(document).ready ->
  $.ajax({url: "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.1.3/js.cookie.js", dataType: "script"}).success ->

    $('<span>Checkout</span>').addClass('rmText').appendTo($('<a></a>').addClass("rmLink").addClass("rmRootLink").attr("href","https://semenhub.shop/cart/"+encodeURIComponent(Cookies.get("UniqueUser"))).appendTo($('<li>').addClass('rmItem').addClass("raLast").insertAfter($('.pageHeader .pageNavigation ul li:last-of-type').removeClass('rmLast'))))

    link = $('<a>Add To Cart</a>').addClass('btn').addClass('btn-default').attr('style','display: inline-block;').insertAfter($('#amsweb_pagemodule_AnimalDetail_tColLinks > .t-row:first-of-type a:last-of-type'))
    link.on 'click', ->
      link.attr('disabled','') #UniqueUser cookie is from HiredHands website, I am stealing it for my own uses....
      get = $.ajax({url: "https://semenhub.shop/cart/" + encodeURIComponent(Cookies.get("UniqueUser")) + "/add?animalid=<%= @animal.id %>", dataType: "jsonp", jsonpCallback: "window.added_to_cart"})
