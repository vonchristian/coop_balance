require 'rails_helper'

module CoopServicesModule
  describe Program do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :account }
      it { is_expected.to have_many :program_subscriptions }
      it { is_expected.to have_many :member_subscribers }
      it { is_expected.to have_many :employee_subscribers }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :contribution }
      it { is_expected.to validate_numericality_of :contribution }
      it { is_expected.to validate_presence_of :account_id }
    end
    it ".default_programs" do
      default_program = create(:program, default_program: true)
      not_default_program = create(:program, default_program: false)

      expect(described_class.default_programs).to include(default_program)
      expect(described_class.default_programs).to_not include(not_default_program)
    end
  end
end