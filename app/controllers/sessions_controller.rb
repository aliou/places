class SessionsController < ApplicationController
  skip_before_filter :authenticate!

  # GET /auth/:provider/callback
  def create
    user = User.from_omniauth(auth_hash)
    if user.nil? or (!user.persisted?)
      return redirect_to auth_failure_path
    end
    redirection_path = after_auth_path

    reset_session
    session[:user_id] = user.id
    redirect_to redirection_path, flash:
      { success: I18n.t('session.create.flash.success') }
  end

  # GET /signout
  def destroy
    reset_session
    redirect_to root_path, flash:
      { success: I18n.t('session.destroy.flash.success') }
  end

  # GET /auth/failure
  def failure
    redirect_to root_path, flash:
      { error: I18n.t('session.failure.flash.error') }
  end

  private

  # Private: Exposes the authentification Hash from Omniauth.
  #
  # Returns: A Hash with the Foursquare authentification details.
  def auth_hash
    request.env['omniauth.auth']
  end

  # Private: The path to redirect the user to after authentification.
  #
  # Returns: A string the path.
  def after_auth_path
    session[:redirect_to].present? ? session[:redirect_to] : places_path
  end
end
