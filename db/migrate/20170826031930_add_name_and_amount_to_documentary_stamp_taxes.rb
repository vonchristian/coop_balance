class AddNameAndAmountToDocumentaryStampTaxes < ActiveRecord::Migration[5.1]
  def change
    add_column :documentary_stamp_taxes, :amount, :decimal
    add_column :documentary_stamp_taxes, :name, :string
  end
end
