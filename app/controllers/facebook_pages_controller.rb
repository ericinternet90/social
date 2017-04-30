class FacebookPagesController < ApplicationController
  before_action :ensure_current_user

  def index
    @facebook_pages = []

    # TODO: verify permissions?
    facebook_token.pages.each do |api_page|
      facebook_page = FacebookPage.find_or_initialize_by(
        user: current_user,
        facebook_page_id: api_page.fetch('id')
      )

      if facebook_page.name != api_page.fetch('name')
        facebook_page.update!(name: api_page.fetch('name'))
      end

      @facebook_pages << facebook_page
    end
  end

private

  def facebook_token
    @facebook_token ||= current_user.facebook_tokens.last

    if @facebook_token.nil? || @facebook_token.expired? # TODO: todo: verify?
      flash.notice = 'You need to connect to Facebook to manage your pages.'
      redirect_to root_path # TODO: redirect directly to auth route?
    end

    @facebook_token
  end

end
