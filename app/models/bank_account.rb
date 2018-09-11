class BankAccount < ApplicationRecord
  has_one_attached :avatar
  belongs_to :cooperative
  belongs_to :account,                 class_name: "AccountingModule::Account"
  belongs_to :earned_interest_account, class_name: "AccountingModule::Account"

  validates :bank_name, :bank_address, :account_number, presence: true
  validates :account_id, :earned_interest_account_id, presence: true
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
  before_save :set_default_image
  def balance
   account.balance(commercial_document: self)
  end

  def deposits
   account.debits_balance(commercial_document: self)
  end

  def withdrawals
    account.credits_balance(commercial_document: self)
  end

  def earned_interests
    earned_interest_account.balance(commercial_document: self)
  end
  private
  def set_default_image
    if avatar.attachment.blank?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'bank.png')), filename: 'default-image.png', content_type: 'image/png')
    end
  end
end
