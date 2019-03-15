require 'rails_helper'

module Cooperatives
  describe Office do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :loans }
      it { is_expected.to have_many :amortization_schedules }
      it { is_expected.to have_many :savings }
      it { is_expected.to have_many :time_deposits }
      it { is_expected.to have_many :share_capitals }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :bank_accounts }
      it { is_expected.to have_many :loan_applications }
      it { is_expected.to have_many :vouchers }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :saving_products }
      it { is_expected.to have_many :share_capital_products }
      it { is_expected.to have_many :loan_products }
      it { is_expected.to have_many :programs }

    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :contact_number }
      it { is_expected.to validate_presence_of :address }
      it { is_expected.to validate_uniqueness_of :name }
    end

    it ".types" do
      expect(described_class.types).to eql ["Cooperatives::Offices::MainOffice", "Cooperatives::Offices::SatelliteOffice", "Cooperatives::Offices::BranchOffice"]
    end

    it "#normalized_type" do
      office = build(:office, type: "Cooperatives::Offices::MainOffice")

      expect(office.normalized_type).to eql "MainOffice"
    end
  end
end
