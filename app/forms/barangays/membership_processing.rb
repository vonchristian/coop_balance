module Barangays
  class MembershipProcessing
    include ActiveModel::Model
    attr_accessor :barangay_membership_id,
                  :barangay_membership_type,
                  :barangay_id,
                  :cooperative_id

    def process!
      return unless valid?

      ActiveRecord::Base.transaction do
        add_member
      end
    end

    def find_barangay
      find_cooperative.barangays.find(barangay_id)
    end

    def find_cooperative
      Cooperative.find(cooperative_id)
    end

    private

    def add_member
      find_barangay.members << find_member
    end

    def find_member
      find_cooperative.member_memberships.find(barangay_membership_id)
    end

    def add_member_accounts_to_barangay
      find_barangay.savings << find_member.savings
      find_barangay.share_capitals << find_member.share_capitals
      find_barangay.loans          << find_member.loans
      find_barangay.time_deposits << find_member.time_deposits
    end
  end
end
