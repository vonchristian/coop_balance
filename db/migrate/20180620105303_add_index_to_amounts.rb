class AddIndexToAmounts < ActiveRecord::Migration[5.2]
  def change
    add_index(:amounts, [:commercial_document_id, :commercial_document_type],name: "index_commercial_documents_on_accounting_amounts")

  end
end
