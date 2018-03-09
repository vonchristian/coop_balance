module CateringServicesModule
  class Menu < ApplicationRecord
    validates :name, presence: true, uniqueness: true
  end
end
