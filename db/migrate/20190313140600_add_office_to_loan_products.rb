class AddOfficeToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :office, foreign_key: true, type: :uuid
  end
end
