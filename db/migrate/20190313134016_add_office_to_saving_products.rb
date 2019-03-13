class AddOfficeToSavingProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :saving_products, :office, foreign_key: true, type: :uuid
  end
end
