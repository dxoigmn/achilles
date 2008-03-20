require File.dirname(__FILE__) + '/../test_helper'

class SeveritiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:severities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_severity
    assert_difference('Severity.count') do
      post :create, :severity => { }
    end

    assert_redirected_to severity_path(assigns(:severity))
  end

  def test_should_show_severity
    get :show, :id => severities(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => severities(:one).id
    assert_response :success
  end

  def test_should_update_severity
    put :update, :id => severities(:one).id, :severity => { }
    assert_redirected_to severity_path(assigns(:severity))
  end

  def test_should_destroy_severity
    assert_difference('Severity.count', -1) do
      delete :destroy, :id => severities(:one).id
    end

    assert_redirected_to severities_path
  end
end
