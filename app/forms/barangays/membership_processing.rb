module Barangays
	class MembershipProcessing
		include ActiveModel::Model
	  attr_accessor :barangay_membership_id, 
	  :barangay_membership_type, 
	  :barangay_id, 
	  :cooperative_id


	  def process!
	  	if valid?
		  	ActiveRecord::Base.transaction do
		      add_member
		    end
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
	  	find_barangay.barangay_members.create(
	  		barangay_membership_id:   barangay_membership_id,
	  		barangay_membership_type: barangay_membership_type
	  	)
	  end

	  def find_member
	  	find_cooperative.members.find(barangay_membership_id)
	  end

	  def add_member_accounts_to_barangay
	  	find_barangay.member_savings << find_member.savings
	  	find_barangay.member_share_capitals << find_member.share_capitals
	  	find_barangay.member_loans << find_member.loans
	  end
	end
end