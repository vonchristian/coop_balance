require 'rails_helper'

module AccountingModule
  describe LevelTwoAccountCategoryRegistration, type: :model do
    describe 'attributes' do
      it { is_expected.to respond_to(:type) }
      it { is_expected.to respond_to(:title) }
      it { is_expected.to respond_to(:code) }
      it { is_expected.to respond_to(:office_id) }
      it { is_expected.to respond_to(:level_three_account_category_id) }

    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :type }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :office_id }
      it { is_expected.to validate_inclusion_of(:type).in_array(AccountingModule::Account::TYPES) }
    end



    it "#normalized_type" do
      office = create(:office)
      expect(described_class.new(
        title: 'test title',
        type: 'Asset',
        code: 'test code',
        office_id: office.id
      ).normalized_type).to eql "AccountingModule::AccountCategories::LevelTwoAccountCategories::Asset"
    end

    it "#register!" do
      office = create(:office)
      described_class.new(
        title: 'test title',
        type: 'Asset',
        code: 'test code',
        contra: true,
        office_id: office.id).register!
      category = office.level_two_account_categories.where(title: 'test title').last

      expect(category.title).to eql 'test title'
      expect(category.code).to eql 'test code'
      expect(category.office_id).to eql office.id
      expect(category.class).to eql AccountingModule::AccountCategories::LevelTwoAccountCategories::Asset
      expect(category.contra?).to be true
    end
  end
end
