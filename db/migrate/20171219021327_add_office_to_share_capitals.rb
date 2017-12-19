class AddOfficeToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capitals, :office, foreign_key: true, type: :uuid
  end
end
