module StoreFrontModule
  module Orders
    class SpoilagesController < ApplicationController
      def index
        @spoilages = if params[:search].present?
                       StoreFrontModule::Orders::SpoilageOrder
                         .includes(:commercial_document, :spoilage_line_items, :line_items, :employee)
                         .text_search(params[:search])
                         .order(date: :desc)
                         .paginate(page: params[:page], per_page: 30)
                     else
                       StoreFrontModule::Orders::SpoilageOrder
                         .includes(:commercial_document, :spoilage_line_items, :line_items, :employee)
                         .order(date: :desc)
                         .paginate(page: params[:page], per_page: 30)
                     end
      end

      def create
        @cart = current_cart
        @spoilage_order = StoreFrontModule::Orders::SpoilageOrderProcessing.new(spoilage_processing_params)
        if @spoilage_order.process!
          @spoilage_order.process!
          redirect_to new_store_front_module_spoilage_line_item_url, notice: 'Spoilage Order processed successfully.'
        else
          redirect_to new_store_front_module_spoilage_line_item_url, alert: 'Error processing spoilage order.'
        end
      end

      private

      def spoilage_processing_params
        params.require(:store_front_module_orders_spoilage_order_processing).permit(:date, :employee_id, :cart_id, :description)
      end
    end
  end
end
