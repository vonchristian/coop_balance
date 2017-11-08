require 'rails_helper'

module CoopConfigurationsModule
RSpec.describe AccountReceivableStoreConfig, type: :model do
  describe 'associations' do
      it { is_expected.to belong_to :account }
    end
  end
end
