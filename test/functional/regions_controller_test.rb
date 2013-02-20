require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  setup do
    @region = regions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:regions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create region" do
    assert_difference('Region.count') do
      post :create, region: { code: @region.code, continent: @region.continent, iso_country: @region.iso_country, keywords: @region.keywords, local_code: @region.local_code, name: @region.name, wikipedia_link: @region.wikipedia_link }
    end

    assert_redirected_to region_path(assigns(:region))
  end

  test "should show region" do
    get :show, id: @region
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @region
    assert_response :success
  end

  test "should update region" do
    put :update, id: @region, region: { code: @region.code, continent: @region.continent, iso_country: @region.iso_country, keywords: @region.keywords, local_code: @region.local_code, name: @region.name, wikipedia_link: @region.wikipedia_link }
    assert_redirected_to region_path(assigns(:region))
  end

  test "should destroy region" do
    assert_difference('Region.count', -1) do
      delete :destroy, id: @region
    end

    assert_redirected_to regions_path
  end
end
