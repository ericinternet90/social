class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

private

  def ensure_current_user
    unless current_user
      flash.notice = 'You need to be logged in before you can do that.'
      redirect_to new_user_session_path
    end
  end

end
