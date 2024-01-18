module IdentificationModule
  class IdentityProvider < ApplicationRecord
    has_many :issued_identities, class_name: 'IdentificationModule::Identification'

    validates :name, :abbreviated_name, :account_number, presence: true, uniqueness: true
  end
end
