require 'rails_helper'

module SavingsModule 
  describe SavingsAgingGroup do
    describe 'associations' do 
      it { is_expected.to belong_to :office }
    end 
    
    describe 'associations' do 
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :start_num }
      it { is_expected.to validate_presence_of :end_num }
      it 'validate_uniqueness_of(:title).scoped_to(:office_id)' do 
        office      = create(:office)
        create(:savings_aging_group, office: office, title: '0-30-days')
        aging_group = build(:savings_aging_group, office: office, title: '0-30-days')
        aging_group.save 

        expect(aging_group.errors[:title]).to eql ['has already been taken']
      end 
    end 
  end 
end
