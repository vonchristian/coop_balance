require 'rails_helper'

module Programs
  module PaymentStatusFinders
    describe Annually do
      it 'paid?' do
        program              = create(:program, payment_schedule_type: 'annually', amount: 1_000)
        program_subscription = create(:program_subscription, program: program)
        asset                = create(:asset)
        entry                = build(:entry, entry_date: Date.current)
        entry.debit_amounts.build(amount: 1000, account: asset)
        entry.credit_amounts.build(amount: 1000, account: program_subscription.program_account)
        entry.save!

        expect(program_subscription.paid?(date: Date.current)).to be true
        expect(program_subscription.paid?(date: Date.current.next_year)).to be false
      end
    end
  end
end
