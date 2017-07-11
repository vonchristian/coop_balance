class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied



  private
  def current_cart
      StoreModule::Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = StoreModule::Cart.create(user_id: current_user.id)
      session[:cart_id] = cart.id
      cart
    end
  def permission_denied
    redirect_to root_path, alert: 'Sorry but you are not allowed to access this feature.'
  end
end
