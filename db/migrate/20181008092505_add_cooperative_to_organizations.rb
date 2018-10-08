class AddCooperativeToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_reference :organizations, :cooperative, foreign_key: true, type: :uuid
  end
end
