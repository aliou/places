require 'rails_helper'

feature 'the signin process' do
  scenario 'redirects to foursquare' do
    visit root_path
    expect(page).to have_content I18n.t('home.tagline')
  end

  scenario 'with a connected user' do
    user = FactoryGirl.create(:user)
    page.set_rack_session(user_id: user.id)
    visit root_path
    expect(page.current_path).to eq(places_path)
  end
end
