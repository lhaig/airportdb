require 'test_helper'

class AirportsControllerTest < ActionController::TestCase
  setup do
    @airport = airports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:airports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create airport" do
    assert_difference('Airport.count') do
      post :create, airport: { continent: @airport.continent, country_id: @airport.country_id, elevation_ft: @airport.elevation_ft, gps_code: @airport.gps_code, home_link: @airport.home_link, iata_code: @airport.iata_code, ident: @airport.ident, keywords: @airport.keywords, latitude_deg: @airport.latitude_deg, local_code: @airport.local_code, longitude_deg: @airport.longitude_deg, municipality: @airport.municipality, name: @airport.name, region_id: @airport.region_id, scheduled_service: @airport.scheduled_service, type: @airport.type, wikipedia_link: @airport.wikipedia_link }
    end

    assert_redirected_to airport_path(assigns(:airport))
  end

  test "should show airport" do
    get :show, id: @airport
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @airport
    assert_response :success
  end

  test "should update airport" do
    put :update, id: @airport, airport: { continent: @airport.continent, country_id: @airport.country_id, elevation_ft: @airport.elevation_ft, gps_code: @airport.gps_code, home_link: @airport.home_link, iata_code: @airport.iata_code, ident: @airport.ident, keywords: @airport.keywords, latitude_deg: @airport.latitude_deg, local_code: @airport.local_code, longitude_deg: @airport.longitude_deg, municipality: @airport.municipality, name: @airport.name, region_id: @airport.region_id, scheduled_service: @airport.scheduled_service, type: @airport.type, wikipedia_link: @airport.wikipedia_link }
    assert_redirected_to airport_path(assigns(:airport))
  end

  test "should destroy airport" do
    assert_difference('Airport.count', -1) do
      delete :destroy, id: @airport
    end

    assert_redirected_to airports_path
  end
end
