class SessionsController < ApplicationController

  skip_before_filter :authenticate!

  def create
    user = User.find_or_create_with_omniauth(auth_hash)

    unless user and user.persisted? and user.valid?
      failure
      return
    end

    reset_session
    session[:user_id] = user.id
    redirect_to root_url, flash: { success: 'You have been signed in.' }
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'You have been signed out.'
  end

  def failure
    redirect_to root_url, flash: { error: "An error occured. Please try again." }
  end

  private

  # Private: Exposes the authentification Hash from Omniauth.
  #
  # Returns: A Hash with the Foursquare authentification details.
  def auth_hash
    request.env['omniauth.auth']
  end
end
