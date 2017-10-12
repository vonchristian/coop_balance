class User < ApplicationRecord
  LOAN_APPROVERS = ["Manager", "Loan Officer"]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:system_administrator, :manager, :loan_officer, :bookkeeper, :teller, :stock_custodian, :sales_clerk, :treasurer, :accountant]
  belongs_to :department
  has_many :entries, class_name: "AccountingModule::Entry", foreign_key: 'recorder_id'
  has_many :fund_transfers, class_name: "AccountingModule::Entry", as: :commercial_document

  has_many :appraised_properties, class_name: "Appraisal", foreign_key: 'appraiser_id'
  has_many :voucher_amounts, as: :commercial_document # for adding cash advance on voucher
  has_many :cash_disbursement_vouchers, as: :payee, class_name: "Voucher"
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
  :url => "/system/:attachment/:id/:basename_:style.:extension"
validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  def self.loan_approvers 
    all.select{|a| User::LOAN_APPROVERS.include?(a.role.titleize)}
  end
  def name  #for voucher index
    first_and_last_name
  end
  def first_and_last_name
    "#{first_name} #{last_name}"
  end
  def cash_on_hand_account
    if treasurer?
      AccountingModule::Asset.find_by(name: "Cash on Hand (Treasury)")
    elsif teller?
      AccountingModule::Asset.find_by(name: "Cash on Hand (Teller)")
    end 
  end 
  def fund_transfer_total
    fund_transfers.fund_transfer.map{ |a| a.debit_amounts.distinct.sum(:amount) }.sum
  end
  def payable_amount 
    voucher_amounts.sum(:amount)
  end
        
end
