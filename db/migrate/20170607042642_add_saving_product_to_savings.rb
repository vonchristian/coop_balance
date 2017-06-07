class AddSavingProductToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :saving_product, foreign_key: true, type: :uuid
  end
end
