require 'rails_helper'

describe Ownership, type: :model do
  describe 'associations' do 
  	it { is_expected.to belong_to :ownable }
  	it { is_expected.to belong_to :owner }
  end 
end 
