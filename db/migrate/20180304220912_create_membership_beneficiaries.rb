class CreateMembershipBeneficiaries < ActiveRecord::Migration[5.1]
  def change
    create_table :membership_beneficiaries, id: :uuid do |t|
      t.belongs_to :membership, foreign_key: true, type: :uuid
      t.references :beneficiary, polymorphic: true, type: :uuid, index: { name: 'inde_beneficiary_on_membership_beneficiaries' }

      t.timestamps
    end
  end
end
