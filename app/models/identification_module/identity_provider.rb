module IdentificationModule
  class IdentityProvider < ApplicationRecord
    has_many :issued_identities, class_name: "IdentificationModule::Identification", foreign_key: 'identity_provider_id'

    validates :name, :abbreviated_name, presence: true, uniqueness: true
  end
end
