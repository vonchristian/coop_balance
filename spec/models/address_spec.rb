require 'rails_helper'

describe Address do
  describe 'associations' do 
  	it { is_expected.to belong_to :addressable }
  end 

  it "#details" do 
  	address = build(:address, street: "Poblacion", barangay: "Poblacion West", municipality: "Lamut", province: "Ifugao")

  	expect(address.details).to eql("Poblacion, Poblacion West, Lamut, Ifugao")
  end
end
