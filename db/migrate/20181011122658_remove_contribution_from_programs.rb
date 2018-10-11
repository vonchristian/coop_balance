class RemoveContributionFromPrograms < ActiveRecord::Migration[5.2]
  def change
    remove_column :programs, :contribution, :decimal
  end
end
