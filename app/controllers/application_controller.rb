class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  private
  def current_cooperative
    cooperative = current_user.cooperative
    session[:cooperative_id] = cooperative.id
    cooperative
  end
  def current_cart
      StoreModule::Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
      cart = StoreModule::Cart.create(user_id: current_user.id)
      session[:cart_id] = cart.id
      cart
  end


  def current_stock_registry
    StockRegistry.find(session[:stock_registry_id])
    rescue ActiveRecord::RecordNotFound
    registry = StockRegistry.create
    session[:stock_registry_id] = registry.id
    registry
  end
  def permission_denied
    redirect_to "/", alert: 'Sorry but you are not allowed to access this feature.'
  end
end
