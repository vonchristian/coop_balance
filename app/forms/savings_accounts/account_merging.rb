module SavingsAccounts
  class AccountMerging
    include ActiveModel::Model
    attr_accessor :saving_id, :cart_id

    def merge!
      ActiveRecord::Base.transaction do
        merge_accounts
      end
    end

    private

    def merge_accounts
      find_cart.savings.each do |saving|
        find_saving.debit_amounts << saving.debit_amounts
        find_saving.credit_amounts << saving.credit_amounts
        saving.destroy
      end
    end

    def find_saving
      DepositsModule::Saving.find(saving_id)
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
  end
end
