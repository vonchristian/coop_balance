class AddCartToLoanApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_applications, :cart,  foreign_key: true, type: :uuid
  end
end
