require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get users_summary" do
    get :users_summary
    assert_response :success
  end

end
