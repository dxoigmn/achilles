require File.dirname(__FILE__) + '/../test_helper'

class PluginsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:plugins)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_plugin
    assert_difference('Plugin.count') do
      post :create, :plugin => { }
    end

    assert_redirected_to plugin_path(assigns(:plugin))
  end

  def test_should_show_plugin
    get :show, :id => plugins(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => plugins(:one).id
    assert_response :success
  end

  def test_should_update_plugin
    put :update, :id => plugins(:one).id, :plugin => { }
    assert_redirected_to plugin_path(assigns(:plugin))
  end

  def test_should_destroy_plugin
    assert_difference('Plugin.count', -1) do
      delete :destroy, :id => plugins(:one).id
    end

    assert_redirected_to plugins_path
  end
end
