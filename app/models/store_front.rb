class StoreFront < ApplicationRecord
  belongs_to :cooperative
  has_many :entries, class_name: "AccountingModule::Entry"
end
