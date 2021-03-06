class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!
  helper_method :current_user

  private

  # Private: Make sure the user is connected.
  #
  # Returns nothing.
  def authenticate!
    unless session[:user_id].present?
      session[:redirect_to] = request.path
      redirect_to root_path,
        flash: { error: I18n.t('application.authenticate.error') }
    end
  end

  # Private: Find the current authenticated User.
  #
  # Returns the current authenticated User.
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
