require 'rails_helper'

describe 'home/index' do
  it 'displays the App name' do
    render
    expect(rendered).to include('Places')
  end

  it 'displays the tagline' do
    render
    expect(rendered).to include(t('home.index.tagline'))
  end

  it 'displays the connection button' do
    render
    expect(rendered).to include('Login with Foursquare')
  end
end
