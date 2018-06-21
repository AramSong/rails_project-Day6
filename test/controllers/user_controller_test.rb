require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_index_url
    assert_response :success
  end

  test "should get edit" do
    get user_edit_url
    assert_response :success
  end

  test "should get show" do
    get user_show_url
    assert_response :success
  end

  test "should get sign_up" do
    get user_sign_up_url
    assert_response :success
  end

end
