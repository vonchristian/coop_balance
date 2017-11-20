require 'rails_helper'

module TimeDepositsModule
  describe FixedTerm do
    describe 'associations' do
      it { is_expected.to belong_to :time_deposit }
    end

    it "#matured?" do
      fixed_term =create(:fixed_term, deposit_date: Date.today.last_month, number_of_days: 10)

      expect(fixed_term.matured?).to be true
    end

    it "#set_default_date" do
      fixed_term = create(:fixed_term)

      expect(fixed_term.deposit_date.to_date).to eql(Time.zone.now.to_date)
    end

    it "#set_maturity_date" do
      fixed_term = create(:fixed_term, deposit_date: Date.today, number_of_days: 30)

      expect(fixed_term.maturity_date.to_date).to eql(Date.today + 30.days)
    end
  end
end
