module Contactable
  extend ActiveSupport::Concern
  included do
    has_many :contacts, as: :contactable
    delegate :number, to: :current_contact, prefix: true

    def current_contact
      contacts.current || NullContact.new
    end
  end
end
