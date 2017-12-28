module Invoices
  class SalesInvoice < Invoice

  def self.create_invoice(invoicable)
    invoicable.create_invoice(number: Invoice.generate_number)
  end
end
