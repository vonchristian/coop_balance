class AddBorrowerToLoans < ActiveRecord::Migration[5.1]
  def change
    add_reference :loans, :borrower, polymorphic: true, type: :uuid
  end
end
