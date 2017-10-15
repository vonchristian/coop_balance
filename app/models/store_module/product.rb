module StoreModule
  class Product < ApplicationRecord
    include PgSearch
    multisearchable against: [:name]
    # has_many :finished_good_materials
    has_many :stocks, class_name: "StoreModule::ProductStock"
    has_many :sold_items, through: :stocks, source: :sold_items
    has_attached_file :photo,
    styles: { large: "120x120>",
             medium: "70x70>",
             thumb: "40x40>",
             small: "30x30>",
             x_small: "20x20>"},
    default_url: ":style/default_product.jpg",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
    validates_attachment_size :photo, :in => 0.megabytes..4.megabytes, :message => 'must be smaller than 4mb'
    
    validates :name, presence: true, uniqueness: true
    def in_stock_count 
      deliveries_count - sold_count
    end
    def deliveries_count
      stocks.total 
    end
    def sold_count 
      sold_items.sum(:quantity)
    end

  end
end