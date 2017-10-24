class RemoveMemberFromShareCapitals < ActiveRecord::Migration[5.1]
  def change
    remove_reference :share_capitals, :member, foreign_key: true
  end
end
