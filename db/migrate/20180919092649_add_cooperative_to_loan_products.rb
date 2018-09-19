class AddCooperativeToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :cooperative, foreign_key: true, type: :uuid
  end
end
