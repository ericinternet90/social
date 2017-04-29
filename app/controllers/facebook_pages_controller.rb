class FacebookPagesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_token

  def index
    @facebook_pages = []
    @facebook_token.pages.each do |api_page|
      @facebook_pages << find_or_initialize_page(api_page.with_indifferent_access)
    end
  end

private

  # TODO: verify permissions?
  def find_or_initialize_page(api_page)
    facebook_page = FacebookPage.find_or_initialize_by(facebook_page_id: api_page.fetch(:id))
    if facebook_page.persisted?
      should_update = (
        facebook_page.name != api_page.fetch(:name) || facebook_page.category != api_page.fetch(:category)
      ) # TODO: don't even store this?
      facebook_page.update(
        name: api_page.fetch(:name), category: api_page.fetch(:category)
      ) if should_update
    else
      facebook_page.assign_attributes(name: api_page.fetch(:name), category: api_page.fetch(:category))
    end
    facebook_page
  end

  def set_token
    @facebook_token = current_user.facebook_tokens.last
    if @facebook_token.nil? || @facebook_token.expired? # TODO: todo: verify?
      flash.notice = 'You need to connect to Facebook to can manage your pages.'
      redirect_to root_path # TODO: redirect directly to auth routes?
    end
  end

end
