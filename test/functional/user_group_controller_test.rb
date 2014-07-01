require 'test_helper'

class UserGroupControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

<<<<<<< HEAD
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
=======
  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get new" do
    get :new
>>>>>>> user-dev-local
    assert_response :success
  end

end
