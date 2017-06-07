class AddShareCapitalProductToShareCapital < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capitals, :share_capital_product, foreign_key: true, type: :uuid
  end
end
