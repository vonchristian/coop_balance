require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe 'associations' do 
  	it { is_expected.to belong_to :credit_account }
  	it { is_expected.to belong_to :debit_account }
  end
end
