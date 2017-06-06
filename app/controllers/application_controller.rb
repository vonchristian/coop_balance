class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied



  private
  def permission_denied
    redirect_to root_path, alert: 'Sorry but you are not allowed to access this feature.'
  end
end
