module ShareCapitals
  class Merging
    include ActiveModel::Model
    attr_accessor :cart_id, :current_share_capital_id

    def merge!
      ActiveRecord::Base.transaction do
        merge_accounts
      end
    end

    private
    def merge_accounts
      find_cart.share_capitals.each do |share_capital|
        find_current_share_capital.amounts << share_capital.amounts
        share_capital.destroy
      end
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
    def find_current_share_capital
      DepositsModule::ShareCapital.find(current_share_capital_id)
    end
  end
end
