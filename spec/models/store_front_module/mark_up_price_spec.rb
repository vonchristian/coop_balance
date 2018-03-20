require 'rails_helper'

module StoreFrontModule
  describe MarkUpPrice do
    describe 'associations' do
      it { is_expected.to belong_to :unit_of_measurement }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :price }
      it { is_expected.to validate_numericality_of :price }
    end

    it ".current" do
      old_price  = create(:mark_up_price, date: Date.yesterday)
      new_price = create(:mark_up_price, date: Date.today)

      expect(StoreFrontModule::MarkUpPrice.current).to eql(new_price)
    end
    it ".set_default_date" do
      price = create(:mark_up_price)

      expect(price.date.strftime("%B %e, %Y")).to eql Time.now.strftime("%B %e, %Y")
    end
  end
end
