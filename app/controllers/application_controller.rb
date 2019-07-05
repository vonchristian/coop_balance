class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  helper_method :current_cooperative, :current_cart, :current_office, :current_store_front

  private
  def current_cart
      StoreFrontModule::Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
      cart = StoreFrontModule::Cart.create(user_id: current_user.id)
      session[:cart_id] = cart.id
      cart
  end

  def current_cooperative
    current_user.cooperative
  end

  def current_office
    params[:office_id].present? ? current_cooperative.offices.find_by(id: params[:office_id]) : current_user.office
  end

  def current_store_front
    current_user.store_front
  end

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
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
  private :current_cooperative, :current_office
end
