require 'rails_helper'

module StoreFrontModule
  describe Product do
    context "associations" do
        it { is_expected.to belong_to :category }
    	it { is_expected.to have_many :stocks }
        it { is_expected.to have_many :sold_items }
    end
    context 'validations' do
    	it { is_expected.to validate_presence_of :name }
    	it { is_expected.to validate_uniqueness_of :name }
    end

    it { is_expected.to have_attached_file(:photo) }
    it { is_expected.to validate_attachment_content_type(:photo).
    	allowing('image/png', 'image/gif').
    	rejecting('text/plain', 'text/xml') }
    it { should validate_attachment_size(:photo).
      less_than(4.megabytes) }
  end
end
