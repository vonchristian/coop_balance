module Members
  class AccountMerging
    include ActiveModel::Model
    attr_accessor :current_member_id, :old_member_id, :cart_id

    def save
      ActiveRecord::Base.transaction do
        create_cart_members
      end
    end

    private

    def create_cart_members
      find_cart.members << find_member
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end

    def find_member
      Member.find(old_member_id)
    end
  end
end
