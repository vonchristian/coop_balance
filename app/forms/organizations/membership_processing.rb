module Organizations
	class MembershipProcessing
		include ActiveModel::Model
	  attr_accessor :organization_membership_id, 
	  :organization_membership_type, 
	  :organization_id, 
	  :cooperative_id

	  def process!
	  	if valid?
		  	ActiveRecord::Base.transaction do
		      add_member
		      add_member_accounts_to_organization
		    end
		  end
	  end

	  def find_organization
	  	find_cooperative.organizations.find(organization_id)
	  end

	  def find_cooperative
	  	Cooperative.find(cooperative_id)
	  end

	  private
	  def add_member
	  	if find_member.organization_memberships.present?
	  		find_member.organization_memberships.destroy_all
	  	end
	  	find_organization.organization_members.create(
	  		organization_membership_id:   organization_membership_id,
	  		organization_membership_type: organization_membership_type
	  	)
	  end

	  def find_member
	  	find_cooperative.member_memberships.find(organization_membership_id)
	  end

	  def add_member_accounts_to_organization
	  	find_organization.member_savings << find_member.savings
	  	find_organization.member_share_capitals << find_member.share_capitals
	  	find_organization.member_loans << find_member.loans
	  end
	end
end