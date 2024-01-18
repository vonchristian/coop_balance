require 'rails_helper'

module Programs
  module PaymentStatusFinders
    describe OneTimePayment do
      it 'paid?' do
        program              = create(:program, payment_schedule_type: 'one_time_payment', amount: 1_000)
        program_subscription = create(:program_subscription, program: program)
        asset                = create(:asset)
        entry                = build(:entry, entry_date: Date.current)
        entry.debit_amounts.build(amount: 1000, account: asset)
        entry.credit_amounts.build(amount: 1000, account: program_subscription.program_account)
        entry.save!

        expect(program_subscription.paid?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to be true
        expect(program_subscription.paid?(from_date: Date.current.beginning_of_year.next_year, to_date: Date.current.next_year.end_of_year)).to be true
      end
    end
  end
end
