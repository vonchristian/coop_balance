class Cooperative < ApplicationRecord
  has_many :offices, class_name: "CoopConfigurationsModule::Office"
  has_many :store_fronts, as: :business
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true
   has_attached_file :logo,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
  :url => "/system/:attachment/:id/:basename_:style.:extension"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

end
