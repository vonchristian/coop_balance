require 'rails_helper'

module Programs
  module PaymentStatusFinders
    describe OneTimePayment do
      it "paid?" do
        program = create(:program, payment_schedule_type: 'one_time_payment')
        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry        = build(:entry, previous_entry: origin_entry, cooperative: cooperative,  entry_date: Date.current)
        entry.debit_amounts.build(amount: 100, account: asset, commercial_document: program)
        entry.credit_amounts.build(amount: 100, account: program.account, commercial_document: program)
        entry.save!

        expect(program.paid?).to be true

      end
    end
  end
end
