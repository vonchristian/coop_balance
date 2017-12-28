class AddInvoiceableToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :invoiceable, polymorphic: true, type: :uuid
  end
end
