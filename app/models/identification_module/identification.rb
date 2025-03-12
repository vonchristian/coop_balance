module IdentificationModule
  class Identification < ApplicationRecord
    belongs_to :identifiable, polymorphic: true
    belongs_to :identity_provider, class_name: "IdentificationModule::IdentityProvider"
    has_many_attached :photos

    delegate :name, to: :identity_provider, prefix: true
  end
end
