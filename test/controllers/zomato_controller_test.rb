require 'test_helper'

class ZomatoControllerTest < ActionController::TestCase
  test 'should get locations json with coordinates' do
    get :locations, { 'lat' => 38.681731, 'lon' => -9.153106,
                      'q' => '', :format => :json }
    assert_response :success
    body = JSON.parse(response.body)
    assert body['status'] == 'success'
    assert_not_empty body['location_suggestions']
  end

  test 'should get locations json without coordinates' do
    get :locations, { 'q' => 'sintr', :format => :json }
    assert_response :success
    body = JSON.parse(response.body)
    assert body['status'] == 'success'
    assert_not_empty body['location_suggestions']
  end

  test 'should get restaurants json without coordinates' do
    get :restaurants, { 'q' => 'soul sushi', :format => :json }
    assert_response :success
    body = JSON.parse(response.body)
    assert body['results_found'].to_i > 0
    assert_not_empty body['restaurants']
  end

  test 'should get restaurants json with coordinates' do
    get :restaurants, { 'lat' => 38.681731, 'lon' => -9.153106,
                        'q' => '', :format => :json }
    assert_response :success
    body = JSON.parse(response.body)
    assert body['results_found'].to_i > 0
    assert_not_empty body['restaurants']
  end

  test 'should get restaurants list without coordinates' do
    get :restaurants, { 'q' => 'sintr', :format => :json }
    assert_response :success
    restaurants = assigns(:restaurants)
    assert restaurants['results_found'].to_i > 0, restaurants['results_found']
    assert_select '.res', restaurants['results_shown'].to_i
  end
end
