require 'test_helper'

class CartControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get cart_add_url
    assert_response :success
  end

end
