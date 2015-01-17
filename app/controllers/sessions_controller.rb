class SessionsController < ApplicationController

  skip_before_filter :authenticate!

  # GET /auth/:provider/callback
  # TODO: Redirect to te previous page, to the `places_path` otherwise.
  def create
    user = User.from_omniauth(auth_hash)

    unless user and user.persisted? and user.valid?
      redirect_to auth_failure_path
      return
    end

    reset_session
    session[:user_id] = user.id
    redirect_to places_path, flash: { success: 'You have been signed in.' }
  end

  # GET /signout
  def destroy
    reset_session
    redirect_to root_path, flash: { success: 'You have been signed out.' }
  end

  # GET /auth/failure
  def failure
    redirect_to root_path, flash:
      { error: "An error occured. Please try again." }
  end

  private

  # Private: Exposes the authentification Hash from Omniauth.
  #
  # Returns: A Hash with the Foursquare authentification details.
  def auth_hash
    request.env['omniauth.auth']
  end
end
