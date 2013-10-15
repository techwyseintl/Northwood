require File.dirname(__FILE__) + '/../test_helper'
require 'site_images_controller'

# Re-raise errors caught by the controller.
class SiteImagesController; def rescue_action(e) raise e end; end

class SiteImagesControllerTest < Test::Unit::TestCase
  fixtures :site_images, :users

  def setup
    @controller = SiteImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
  end

  def test_login_is_required
    login_as(false)
    get :index
    assert_response 302
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:images)
  end

  def test_should_create_site_image_when_uploaded
    # TODO
    assert true
  end
  
  def test_should_destroy_site_image
    assert_difference SiteImage, :count, -2 do # It's 2 less b/c the thumb is also deleted
      delete :destroy, :id => 1
      assert_redirected_to site_images_path
    end
  end
end
