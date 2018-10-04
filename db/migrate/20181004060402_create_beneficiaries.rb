class CreateBeneficiaries < ActiveRecord::Migration[5.2]
  def change
    create_table :beneficiaries, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.string :full_name
      t.string :relationship

      t.timestamps
    end
  end
end
