require 'rails_helper'

describe Address do
  describe 'associations' do
  	it { is_expected.to belong_to :addressable }
    it { is_expected.to belong_to :street }
    it { is_expected.to belong_to :barangay }
    it { is_expected.to belong_to :municipality }
    it { is_expected.to belong_to :province }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :street_id }
    it { is_expected.to validate_presence_of :barangay_id }
    it { is_expected.to validate_presence_of :municipality_id }
    it { is_expected.to validate_presence_of :province_id }
  end
  it '.current_address' do
    address = create(:address, current: false)
    current_address = create(:address, current: true)
    expect(Address.current_address).to eql(current_address)
  end
  it "#details" do
    province = create(:province, name: "Ifugao")
    municipality = create(:municipality, name: "Lamut")
    barangay = create(:barangay, name: "Poblacion West", municipality: municipality)
    street = create(:street, name: "Poblacion", barangay: barangay)
  	address = build(:address, street: street, barangay: barangay, municipality: municipality, province: province)

  	expect(address.details).to eql("Poblacion, Poblacion West, Lamut, Ifugao")
  end
end
