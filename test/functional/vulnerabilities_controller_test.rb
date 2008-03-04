require File.dirname(__FILE__) + '/../test_helper'

class VulnerabilitiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vulnerabilities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vulnerability
    assert_difference('Vulnerability.count') do
      post :create, :vulnerability => { }
    end

    assert_redirected_to vulnerability_path(assigns(:vulnerability))
  end

  def test_should_show_vulnerability
    get :show, :id => vulnerabilities(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vulnerabilities(:one).id
    assert_response :success
  end

  def test_should_update_vulnerability
    put :update, :id => vulnerabilities(:one).id, :vulnerability => { }
    assert_redirected_to vulnerability_path(assigns(:vulnerability))
  end

  def test_should_destroy_vulnerability
    assert_difference('Vulnerability.count', -1) do
      delete :destroy, :id => vulnerabilities(:one).id
    end

    assert_redirected_to vulnerabilities_path
  end
end
