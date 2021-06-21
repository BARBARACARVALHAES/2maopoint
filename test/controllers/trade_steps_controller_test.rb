require "test_helper"

class TradeStepsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get trade_steps_show_url
    assert_response :success
  end

  test "should get update" do
    get trade_steps_update_url
    assert_response :success
  end
end
