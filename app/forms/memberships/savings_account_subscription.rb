module Memberships
  class SavingsAccountSubscription
    include ActiveModel::Model
    attr_accessor :depositor_id,  :saving_product_id, :account_number, :amount, :or_number, :date, :employee_id

    validates :saving_product_id, presence: true
    validates :amount, presence: true, numericality: true

    def save
      ActiveRecord::Base.transaction do
        open_savings_account
      end
    end
    def find_savings_account
      MembershipsModule::Saving.find_by(account_number: account_number)
    end

    def find_employee
      User.find_by(id: employee_id)
    end
    def find_depositor
      member_depositor = Member.find_by(id: depositor_id)
      employee_depositor = User.find_by_id(depositor_id)
      if member_depositor.present?
        member_depositor
      elsif employee_depositor.present?
        employee_depositor
      end
    end
    private
    def open_savings_account
      savings_account = MembershipsModule::Saving.create(
        depositor: find_depositor,
        saving_product_id: saving_product_id,
        last_transaction_date: date,
        account_number: account_number)
      AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        commercial_document: find_depositor,
        recorder: find_employee,
        description: "Savings deposit  of #{find_depositor.name}",
        reference_number: or_number,
        entry_date: date,
      debit_amounts_attributes: [
        account: debit_account,
        amount: amount,
        commercial_document: savings_account],
      credit_amounts_attributes: [
        account: credit_account,
        amount: amount,
        commercial_document: savings_account])
    end

    def debit_account
      find_employee.cash_on_hand_account
    end

    def credit_account
      find_savings_product.account
    end

    def find_savings_product
      CoopServicesModule::SavingProduct.find_by_id(saving_product_id)
    end
  end
end
