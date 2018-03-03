class AddCooperatorToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_reference :memberships, :cooperator, polymorphic: true, type: :uuid
  end
end
