require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include Pundit::Authorization
  include Pagy::Backend
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  helper_method :current_cooperative, :current_cart, :current_office, :current_store_front

  private

  def current_cart
    StoreFrontModule::Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = current_user.carts.create!
    session[:cart_id] = cart.id
    cart
  end

  def current_cooperative
    @current_cooperative ||= current_user.cooperative
  end

  def current_office
    @current_office ||= current_user.office
  end

  def current_store_front
    current_user.store_front
  end

  def respond_modal_with(*args, &)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with(*args, options, &)
  end

  def current_stock_registry
    StockRegistry.find(session[:stock_registry_id])
  rescue ActiveRecord::RecordNotFound
    registry = StockRegistry.create
    session[:stock_registry_id] = registry.id
    registry
  end

  def permission_denied
    redirect_to '/', alert: 'Sorry but you are not allowed to access this page.'
  end
end
