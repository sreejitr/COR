require 'test_helper'

class WeightReadingsControllerTest < ActionController::TestCase
  setup do
    @weight_reading = weight_readings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weight_readings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weight_reading" do
    assert_difference('WeightReading.count') do
      post :create, weight_reading: { created_date: @weight_reading.created_date, hydration: @weight_reading.hydration, patient_id: @weight_reading.patient_id, reading_time: @weight_reading.reading_time, weight: @weight_reading.weight, weight_monitor_id: @weight_reading.weight_monitor_id }
    end

    assert_redirected_to weight_reading_path(assigns(:weight_reading))
  end

  test "should show weight_reading" do
    get :show, id: @weight_reading
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weight_reading
    assert_response :success
  end

  test "should update weight_reading" do
    patch :update, id: @weight_reading, weight_reading: { created_date: @weight_reading.created_date, hydration: @weight_reading.hydration, patient_id: @weight_reading.patient_id, reading_time: @weight_reading.reading_time, weight: @weight_reading.weight, weight_monitor_id: @weight_reading.weight_monitor_id }
    assert_redirected_to weight_reading_path(assigns(:weight_reading))
  end

  test "should destroy weight_reading" do
    assert_difference('WeightReading.count', -1) do
      delete :destroy, id: @weight_reading
    end

    assert_redirected_to weight_readings_path
  end
end
