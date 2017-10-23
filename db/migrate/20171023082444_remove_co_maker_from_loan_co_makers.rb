class RemoveCoMakerFromLoanCoMakers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :loan_co_makers, :co_maker, foreign_key: { to_table: :members }
  end
end
