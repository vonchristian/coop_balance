class AddressForm < Reform::Form
  collection :addresses, prepopulator: :build_address,
                         populator: :address_populator do
    property :street
    property :barangay
    property :municipality
    property :province
    property :_destroy, virtual: true
  end
  def build_address(*)
    addresses << Address.new if addresses.blank?
  end
end
