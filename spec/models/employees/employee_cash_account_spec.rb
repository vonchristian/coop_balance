require 'rails_helper'

module Employees
  describe EmployeeCashAccount do
    describe 'associations' do
      it { is_expected.to belong_to :employee }
      it { is_expected.to belong_to :cash_account }
    end
  end
end
