require 'test_helper'

class PatientControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get metrics" do
    get :metrics
    assert_response :success
  end

  test "should get alerts" do
    get :alerts
    assert_response :success
  end

  test "should get patient_plan" do
    get :patient_plan
    assert_response :success
  end

  test "should get activity_log" do
    get :activity_log
    assert_response :success
  end

  test "should get settings" do
    get :settings
    assert_response :success
  end

end
