require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe 'associations' do 
    it { is_expected.to have_many :employee_contributions }
    it { is_expected.to have_many :contributors }
  end 
  describe 'validations' do 
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
    it do 
      is_expected.to validate_numericality_of(:amount)
    end
  end

end
