class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:system_administrator, :general_manager, :loan_officer, :accounting_officer, :teller, :stock_custodian, :store_cashier]
  belongs_to :department
  has_many :entries, class_name: "AccountingDepartment::Entry", foreign_key: 'recorder_id'
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def first_and_last_name
    "#{first_name} #{last_name}"
  end
end
