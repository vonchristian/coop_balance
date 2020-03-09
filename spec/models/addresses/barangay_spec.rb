require 'rails_helper'

module Addresses
  RSpec.describe Barangay do
    describe 'associations' do
      it { is_expected.to belong_to :municipality }
      it { is_expected.to have_many :streets }
      it { is_expected.to have_many :loans }
      it { is_expected.to have_many :savings }
      it { is_expected.to have_many :share_capitals }
      it { is_expected.to have_many :time_deposits }
      it { is_expected.to have_many :addresses }
      it { is_expected.to have_many :members }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:municipality).with_prefix }
    end
  end
end
