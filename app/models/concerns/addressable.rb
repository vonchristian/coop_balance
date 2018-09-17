module Addressable
  extend ActiveSupport::Concern
  included do
    has_many :addresses, as: :addressable

    delegate :details, :complete_address, :barangay_name, :street_name, to: :current_address, prefix: true, allow_nil: true
  end

  def current_location
    addresses.current
  end
end
