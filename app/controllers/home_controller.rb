class HomeController < ApplicationController
  skip_before_filter :authenticate!

  # GET /
  def index
    redirect_to places_path if current_user
  end
end
