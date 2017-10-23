class AddCoMakerToLoanCoMakers < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_co_makers, :co_maker, polymorphic: true, type: :uuid
  end
end
