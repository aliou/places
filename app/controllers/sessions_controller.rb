class SessionsController < ApplicationController
  skip_before_filter :authenticate!

  # GET /auth/:provider/callback
  # TODO: Redirect to te previous page, to the `places_path` otherwise.
  def create
    user = User.from_omniauth(auth_hash)
    if user.nil? or (! user.persisted?)
      return redirect_to auth_failure_path
    end

    reset_session
    session[:user_id] = user.id
    redirect_to places_path, flash:
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
end
