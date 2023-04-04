require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_home_url
    assert_response :success
  end

  test "should get verification" do
    get home_verification_url
    assert_response :success
  end

  test "should get conversations" do
    get home_conversations_url
    assert_response :success
  end

  test "should get send_message" do
    get home_send_message_url
    assert_response :success
  end
end
