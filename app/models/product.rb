class Product < ApplicationRecord
  has_many :finished_good_materials
  has_many :stocks, class_name: "ProductStock"
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

end
