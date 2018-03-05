class AddSlugToLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_products, :slug, :string
    add_index :loan_products, :slug, unique: true
  end
end
