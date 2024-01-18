module ManagementModule
  module Settings
    class CooperativeProductsController < ApplicationController
      def index
        @cooperative = current_cooperative
        @share_capital_products = current_cooperative.share_capital_products
        @time_deposit_products = current_cooperative.time_deposit_products
        @loan_products = current_cooperative.loan_products
        @saving_products = current_cooperative.saving_products
      end
    end
  end
end
