require 'test_helper'

class CafeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cafe_index_url
    assert_response :success
  end

  test "should get show" do
    get cafe_show_url
    assert_response :success
  end

  test "should get edit" do
    get cafe_edit_url
    assert_response :success
  end

  test "should get new" do
    get cafe_new_url
    assert_response :success
  end

end
