require 'rails_helper'

RSpec.describe InterestAmortizationConfig, type: :model do
  it { is_expected.to define_enum_for(:amortization_type).with([:annually, :straight_balance]) }
end
