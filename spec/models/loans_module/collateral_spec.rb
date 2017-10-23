require 'rails_helper'

RSpec.describe LoansModule::Collateral, type: :model do
  describe 'associations' do 
    it { is_expected.to belong_to :loan }
    it { is_expected.to belong_to :real_property }
  end

end
