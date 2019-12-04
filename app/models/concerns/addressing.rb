module Addressing
  extend ActiveSupport::Concern

  included do
    has_many :addresses, as: :addressable

    delegate :details, :complete_address, :barangay_name, :street_name, to: :current_address, prefix: true
  end

  def current_address
    addresses.recent || NullAddress.new
  end
end
