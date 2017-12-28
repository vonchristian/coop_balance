require 'rails_helper'

describe Invoice do
  describe 'associations' do
    it { is_expected.to belong_to :invoiceable }
  end

  describe ".generate_number(invoiceable)" do
    it 'for blank invoice' do
      order = create(:order)

      expect(Invoice.generate_number(order)).to eql "0"
    end

    it 'with invoice' do
      order = create(:order)
      order.create_invoice(number: Invoice.generate_number(order))

      expect(Invoice.generate_number(order)).to be false
    end
    it 'succeeding invoice numbers' do
      order = create(:order)
      order.create_invoice(number: Invoice.generate_number(order))
      another_order = create(:order)
      another_order.create_invoice(number: Invoice.generate_number(another_order))
      third_order = create(:order)

      expect(Invoice.generate_number(order)).to be false
      expect(order.invoice_number).to eql "0"
      expect(another_order.invoice_number).to eql "1"
      expect(Invoice.generate_number(third_order)).to eql "2"
    end
  end
end
