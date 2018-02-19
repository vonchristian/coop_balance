class AddBeneficiaryToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_reference :memberships, :beneficiary, polymorphic: true, type: :uuid
  end
end
