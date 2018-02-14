module StoreFrontModule
  module Products
    class SettingsController < ApplicationController
      def index
        @product = StoreFrontModule::Product.find(params[:product_id])
      end
    end
  end
end
