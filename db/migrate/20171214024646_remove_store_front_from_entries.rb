class RemoveStoreFrontFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_reference :entries, :store_front, foreign_key: true, type: :uuid
    remove_reference :entries, :department, foreign_key: true, type: :uuid
    remove_reference :entries, :section, foreign_key: true, type: :uuid

    remove_reference :entries, :branch_office, foreign_key: true, type: :uuid
    remove_reference :entries, :voucher, foreign_key: true, type: :uuid

  end
end
