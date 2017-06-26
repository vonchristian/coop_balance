require 'rails_helper'

module AccountingDepartment 
	describe Asset do 
    it_behaves_like 'a AccountingDepartment::Account subtype', kind: :asset, normal_balance: :debit
  end
end