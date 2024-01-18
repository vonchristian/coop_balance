require 'rails_helper'

module Programs
  module PaymentStatusFinders
    describe Quarterly do
      it 'paid?' do
        program              = create(:program, payment_schedule_type: 'annually', amount: 1_000)
        program_subscription = create(:program_subscription, program: program)
        asset                = create(:asset)
        entry                = build(:entry, entry_date: Date.current)
        entry.debit_amounts.build(amount: 1000, account: asset)
        entry.credit_amounts.build(amount: 1000, account: program_subscription.program_account)
        entry.save!

        expect(program_subscription.paid?(from_date: Date.current.beginning_of_quarter, to_date: Date.current.end_of_quarter)).to be true
        expect(program_subscription.paid?(from_date: Date.current.beginning_of_year.next_quarter, to_date: Date.current.next_quarter.end_of_quarter)).to be false
      end
    end
  end
end
