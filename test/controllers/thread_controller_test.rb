require 'test_helper'

class ThreadControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get thread_new_url
    assert_response :success
  end

  test "should get create" do
    get thread_create_url
    assert_response :success
  end

end
