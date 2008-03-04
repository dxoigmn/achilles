require File.dirname(__FILE__) + '/../test_helper'

class ScansControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:scans)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_scan
    assert_difference('Scan.count') do
      post :create, :scan => { }
    end

    assert_redirected_to scan_path(assigns(:scan))
  end

  def test_should_show_scan
    get :show, :id => scans(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => scans(:one).id
    assert_response :success
  end

  def test_should_update_scan
    put :update, :id => scans(:one).id, :scan => { }
    assert_redirected_to scan_path(assigns(:scan))
  end

  def test_should_destroy_scan
    assert_difference('Scan.count', -1) do
      delete :destroy, :id => scans(:one).id
    end

    assert_redirected_to scans_path
  end
end
