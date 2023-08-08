module Carts
  class SavingMergingProcessing
    include ActiveModel::Model
    attr_accessor :cart_id, :old_saving_id

    def save
      ActiveRecord::Base.transaction do
        create_saving_merging
      end
    end

    private
    def create_saving_merging
      find_cart.savings << find_saving
    end
    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
    def find_saving
      DepositsModule::Saving.find(old_saving_id)
    end
  end
end
