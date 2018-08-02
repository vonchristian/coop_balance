class AddLastTransactionDateToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :last_transaction_date, :datetime
  end
end
