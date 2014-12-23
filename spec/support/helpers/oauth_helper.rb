module OauthHelper
  def stub_oauth(options = {})
    OmniAuth.config.add_mock(
      :foursquare,
      auth: {
        uid: options[:uid]
      },
      credentials: {
        token: options[:token]
      }
    )
  end
end
