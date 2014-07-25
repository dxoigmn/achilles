# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class SecurityTransgression < StandardError; end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c3412e6be5ef83402305802bbb9b85d9'

  before_filter do |controller|
    controller.session[:user] ||= User.find_by_name(controller.request.env["REMOTE_USER"] || '', :include => [:locations])
    raise SecurityTransgression unless controller.session[:user]
  end

  rescue_from SecurityTransgression do |exception|
    render :file => 'public/403.html', :status => 403
  end
end
