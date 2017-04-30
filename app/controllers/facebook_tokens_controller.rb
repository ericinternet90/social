class FacebookTokensController < ApplicationController
  layout false

  def create
    FacebookToken.create!(
      user: current_user,
      access_token: oauth_response.fetch(:access_token),
      expires_in: oauth_response.fetch(:expires_in)
    )

    redirect_to facebook_pages_path
  end

  def delete
    # TODO: call out to fb to deauthorize. then delete token
  end

  def deauthorize
    # TODO: provide callback for fb deauth
  end

private

  def oauth_response
    @oauth_response ||= HTTParty.get(
      'https://graph.facebook.com/v2.8/oauth/access_token',
      query: { client_id: Config4::Facebook.id,
               redirect_uri: facebook_token_redirect_url,
               client_secret: Config4::Facebook.secret,
               code: params.fetch(:code) }
    ).with_indifferent_access
  end

end
