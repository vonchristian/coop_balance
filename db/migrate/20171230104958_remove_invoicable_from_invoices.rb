class RemoveInvoicableFromInvoices < ActiveRecord::Migration[5.1]
  def change
    remove_reference :invoices, :invoicable, polymorphic: true, type: :uuid
  end
end
