class AddOfficeToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capital_products, :office, foreign_key: true, type: :uuid
  end
end
