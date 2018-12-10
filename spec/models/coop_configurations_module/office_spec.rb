require 'rails_helper'

module CoopConfigurationsModule
  describe Office do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :loans }
      it { is_expected.to have_many :savings }
      it { is_expected.to have_many :time_deposits }
      it { is_expected.to have_many :share_capitals }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :bank_accounts }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :contact_number }
      it { is_expected.to validate_presence_of :address }
      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
