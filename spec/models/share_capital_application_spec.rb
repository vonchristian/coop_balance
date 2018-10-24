require 'rails_helper'

describe ShareCapitalApplication do
  describe 'associations' do
    it { is_expected.to belong_to :subscriber }
    it { is_expected.to belong_to :share_capital_product }
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :office }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :subscriber_id }
    it { is_expected.to validate_presence_of :subscriber_type }
    it { is_expected.to validate_presence_of :share_capital_product_id }
    it { is_expected.to validate_presence_of :office_id }

  end

end
