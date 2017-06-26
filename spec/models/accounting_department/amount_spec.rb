require 'rails_helper'
module AccountingDepartment
  RSpec.describe Amount, type: :model do
    subject { build(:amount) }
    it { is_expected.to_not be_valid }
  end
end
