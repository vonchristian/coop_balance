require 'rails_helper'

RSpec.describe OfficialReceipt, type: :model do
  context 'associations' do 
  	it { is_expected.to belong_to :receiptable }
  end
end
