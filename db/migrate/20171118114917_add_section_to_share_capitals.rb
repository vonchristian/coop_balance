class AddSectionToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capitals, :section, foreign_key: true, type: :uuid
  end
end
