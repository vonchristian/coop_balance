class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  helper_method :current_cooperative, :current_cart, :current_office

  private
  def current_cart
      StoreFrontModule::Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
      cart = StoreFrontModule::Cart.create(user_id: current_user.id)
      session[:cart_id] = cart.id
      cart
  end

  def current_cooperative
    if current_user
      current_user.cooperative
    end
  end

  def current_office
    if current_user
      current_user.office
    end
  end


  def current_stock_registry
    StockRegistry.find(session[:stock_registry_id])
    rescue ActiveRecord::RecordNotFound
    registry = StockRegistry.create
    session[:stock_registry_id] = registry.id
    registry
  end
  def permission_denied
    redirect_to "/", alert: 'Sorry but you are not allowed to access this page.'
  end
end
