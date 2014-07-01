require 'test_helper'

class RiskquestionsControllerTest < ActionController::TestCase
  setup do
    @riskquestion = riskquestions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:riskquestions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create riskquestion" do
    assert_difference('Riskquestion.count') do
      post :create, riskquestion: { image_id: @riskquestion.image_id, question: @riskquestion.question, status: @riskquestion.status }
    end

    assert_redirected_to riskquestion_path(assigns(:riskquestion))
  end

  test "should show riskquestion" do
    get :show, id: @riskquestion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @riskquestion
    assert_response :success
  end

  test "should update riskquestion" do
    put :update, id: @riskquestion, riskquestion: { image_id: @riskquestion.image_id, question: @riskquestion.question, status: @riskquestion.status }
    assert_redirected_to riskquestion_path(assigns(:riskquestion))
  end

  test "should destroy riskquestion" do
    assert_difference('Riskquestion.count', -1) do
      delete :destroy, id: @riskquestion
    end

    assert_redirected_to riskquestions_path
  end
end
