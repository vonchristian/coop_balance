require 'rails_helper'

describe CapitalBuildUp do
  describe 'associations' do 
  	it { is_expected.to belong_to :share_capital }
  end 
end
