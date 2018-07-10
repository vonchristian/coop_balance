class BankAccount < ApplicationRecord
  belongs_to :cooperative
  belongs_to :account, class_name: "AccountingModule::Account"
  belongs_to :earned_interest_account, class_name: "AccountingModule::Account"

  validates :bank_name, :bank_address, :account_number, presence: true
  validates :account_id, :earned_interest_account_id, presence: true
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
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
  def balance
   account.balance(commercial_document_id: self.id)
  end

  def deposits
   account.debits_balance(commercial_document_id: self.id)
  end

  def withdrawals
    account.credits_balance(commercial_document_id: self.id)
  end

  def earned_interests
    earned_interest_account.balance(commercial_document_id: self.id)
  end
end
