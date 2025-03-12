class AddBeneficiariesToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capitals, :beneficiaries, :string
  end
end
