module Members
  class Merging
    include ActiveModel::Model
    attr_accessor :cart_id, :current_member_id

    def merge!
      ActiveRecord::Base.transaction do
        merge_accounts
      end
    end
    private
    def merge_accounts
      find_cart.members.each do |member|
        find_current_member.savings        << member.savings
        find_current_member.share_capitals << member.share_capitals
        find_current_member.loans          << member.loans
        find_current_member.time_deposits  << member.time_deposits
        find_current_member.entries        << member.entries
      end
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
    def find_current_member
      Member.find(current_member_id)
    end
  end
end
