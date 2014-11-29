class HomeController < ApplicationController
  skip_before_filter :authenticate!

  # GET /
  def index
    redirect_to places_path if current_user
    @tagline = ['Remember the places you want to go to.',
                'Plan your escape.'].sample
  end
end
