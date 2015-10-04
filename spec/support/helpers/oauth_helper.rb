module OauthHelper
  def stub_oauth(options = {})
    if options[:provider].nil?
      options[:provider] = :foursquare
    end

    OmniAuth.config.add_mock(
      options[:provider],
      uid: options[:uid],
      credentials: {
        token: options[:token]
      }
    )
  end
end
