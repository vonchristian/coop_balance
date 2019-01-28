require 'rails_helper'

module Programs
  module PaymentStatusFinders
    describe Annually do
      it "paid?" do
        program_1 = create(:program, payment_schedule_type: 'annually', amount: 1_000)
        program_2 = create(:program, payment_schedule_type: 'annually')

        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry        = build(:entry, previous_entry: origin_entry, cooperative: cooperative,  entry_date: Date.current)
        entry.debit_amounts.build(amount: 1000, account: asset, commercial_document: program_1)
        entry.credit_amounts.build(amount: 1000, account: program_1.account, commercial_document: program_1)
        entry.save!

        expect(program_1.paid?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to be true
        expect(program_1.paid?(from_date: Date.current.beginning_of_year.next_year, to_date: Date.current.next_year.end_of_year)).to be false

        expect(program_2.paid?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to be false

      end
    end
  end
end
