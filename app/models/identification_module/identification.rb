module IdentificationModule
  class Identification < ApplicationRecord
    belongs_to :identifiable, polymorphic: true
    belongs_to :identity_provider, class_name: "IdentificationModule::IdentityProvider"
  end
end
