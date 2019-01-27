class Tag < ApplicationRecord
  has_many :taggings
  has_many :taggable_entries, through: :taggings, source: :taggable, source_type: "AccountingModule::Entry"
end
