module OauthHelper
  def stub_oauth
    OmniAuth.config.add_mock(
      :foursquare,
      auth: {
        uid: ENV['FOURSQUARE_USER_ID']
      })
  end
end
