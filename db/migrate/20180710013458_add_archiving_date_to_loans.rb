class AddArchivingDateToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :archiving_date, :datetime
  end
end
