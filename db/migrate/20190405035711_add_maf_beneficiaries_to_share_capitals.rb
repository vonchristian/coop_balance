class AddMafBeneficiariesToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capitals, :maf_beneficiaries, :string
  end
end
