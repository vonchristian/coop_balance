module MembershipApplications
  class PaymentProcessing
    include ActiveModel::Model
    attr_accessor :recorder_id, :date, :description, :reference_number, :membership_id, :recorder_id

    validates :reference_number, :description, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_entry
      end
    end
    def find_membership
      Membership.find_by_id(membership_id)
    end
    def find_employee
      User.find_by(id: recorder_id)
    end
    def save_entry
      entry = AccountingModule::Entry.new(
        commercial_document: find_membership.cooperator,
        :description => description,
        recorder: find_employee,
        entry_date: date)
      find_membership.cooperator.voucher_amounts.each do |amount|
       debit_amount = AccountingModule::DebitAmount.new(
        account: find_employee.cash_on_hand_account ,
        amount: amount.amount,
        commercial_document: find_membership.cooperator)
        credit_amount = AccountingModule::CreditAmount.new(
          account: amount.account,
          amount: amount.amount,
          commercial_document: find_membership.cooperator)
        entry.credit_amounts << credit_amount
        entry.debit_amounts << debit_amount
      end
      entry.save!
      find_membership.cooperator.voucher_amounts.each do |v|
        v.commercial_document_id = nil
        v.commercial_document_type = nil
        v.save
      end
    end

  end
end
