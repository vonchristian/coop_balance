require 'rails_helper'

module Addresses
  RSpec.describe Barangay do
    describe 'associations' do
      it { should belong_to :municipality }
      it { should have_many :streets }
      it { should have_many :loans }
      it { should have_many :savings }
      it { should have_many :share_capitals }
      it { should have_many :time_deposits }
      it { should have_many :addresses }
      it { should have_many :members }
    end

    describe 'validations' do
      it { should validate_presence_of :name }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:municipality).with_prefix }
    end
  end
end
