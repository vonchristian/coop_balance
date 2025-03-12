module MembershipsModule
  class MembershipBeneficiary < ApplicationRecord
    belongs_to :membership,  class_name: "Cooperatives::Membership"
    belongs_to :beneficiary, polymorphic: true
  end
end
