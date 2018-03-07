class RemoveCommercialDocumentFromVouchers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :vouchers, :commercial_document, polymorphic: true, type: :uuid
  end
end
