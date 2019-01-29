require 'rails_helper'

module Registries
  describe LoanRegistry do
    it "#parse_for_records" do
      cooperative = create(:cooperative)
      employee = create(:user, cooperative: cooperative)
      registry = create(:loan_registry, employee: employee, cooperative: cooperative, spreadsheet: File.open(Rails.root.join('spec', 'support', 'registries', 'loan_registry.xlsx')))
      expect(registry.cooperative).to eq cooperative
      registry.parse_for_records
      # expect(cut_off_date(row)).to eql Date.parse('December 31, 2018')

    end
  end
end
