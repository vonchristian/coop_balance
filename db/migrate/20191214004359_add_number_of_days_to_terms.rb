class AddNumberOfDaysToTerms < ActiveRecord::Migration[6.0]
  def change
    add_column :terms, :number_of_days, :integer, default: 0
  end
end
