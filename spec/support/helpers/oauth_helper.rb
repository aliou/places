module OauthHelper
  def stub_oauth(options = {})
    OmniAuth.config.add_mock(
      :foursquare,
      auth: {
        uid: options[:uid] || ENV['FOURSQUARE_USER_ID']
      })
  end
end
