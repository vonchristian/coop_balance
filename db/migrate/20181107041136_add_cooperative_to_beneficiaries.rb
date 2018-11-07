class AddCooperativeToBeneficiaries < ActiveRecord::Migration[5.2]
  def change
    add_reference :beneficiaries, :cooperative, foreign_key: true, type: :uuid
  end
end
