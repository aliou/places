class SessionsController < ApplicationController

  skip_before_filter :authenticate!

  def create
    user = User.where(provider: auth_hash['provider'], uid: auth_hash['uid'].to_s).first
    user = User.create_with_omniauth(auth_hash) if user.nil?

    reset_session
    session[:user_id] = user.id
    redirect_to root_url, notice: 'You have been signed in.'
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'You have been signed out.'
  end

  def failure
    redirect_to root_url,
      notice: "An error occured: #{params[:message].humanize}."
  end

  private

  # Private: Exposes the authentification Hash from Omniauth.
  #
  # Returns: A Hash with the Foursquare authentification details.
  def auth_hash
    request.env['omniauth.auth']
  end
end
