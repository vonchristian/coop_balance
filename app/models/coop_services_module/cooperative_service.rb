module CoopServicesModule
  class CooperativeService < ApplicationRecord
    belongs_to :cooperative

    has_many :entries, class_name: 'AccountingModule::Entry', through: :accounts
  end
end
