module CateringServicesModule
  class Menu < ApplicationRecord
  	has_many :menu_orders, as: :line_itemable, class_name: "StoreModule::LineItem"

    validates :name, presence: true, uniqueness: true
  end
end
