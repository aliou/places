class HomeController < ApplicationController
  skip_before_filter :authenticate!

  # GET /
  def index
    redirect_to places_path if current_user
    @tagline = I18n.t('taglines').sample
  end
end
