module ShareCapitals
  class MergingLineItem
    include ActiveModel::Model
    attr_accessor :cart_id, :old_share_capital_id

    def save
      ActiveRecord::Base.transaction do
        create_cart_share_capital
      end
    end

    private

    def create_cart_share_capital
      find_cart.share_capitals << find_share_capital
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end

    def find_share_capital
      DepositsModule::ShareCapital.find(old_share_capital_id)
    end
  end
end
