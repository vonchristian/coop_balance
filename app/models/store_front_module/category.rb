module StoreFrontModule
  class Category < ApplicationRecord
    belongs_to :cooperative
    has_many :products
    validates :name, presence: true, uniqueness: true
  end
end
