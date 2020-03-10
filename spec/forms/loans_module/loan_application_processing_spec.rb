require 'rails_helper'

module LoansModule
  describe LoanApplicationProcessing, type: :model do 
    describe "attributes" do 
      it { is_expected.to respond_to(:borrower_id) }
      it { is_expected.to respond_to(:borrower_type) }
      it { is_expected.to respond_to(:number_of_days) }
      it { is_expected.to respond_to(:purpose) }
      it { is_expected.to respond_to(:loan_product_id) }
      it { is_expected.to respond_to(:loan_amount) }
      it { is_expected.to respond_to(:application_date) }
      it { is_expected.to respond_to(:mode_of_payment) }
      it { is_expected.to respond_to(:account_number) }
      it { is_expected.to respond_to(:preparer_id) }
      it { is_expected.to respond_to(:cooperative_id) }
      it { is_expected.to respond_to(:office_id) }
    end 
    describe "validations" do 
      it { is_expected.to validate_presence_of :number_of_days }
      it { is_expected.to validate_presence_of :loan_amount }
      it { is_expected.to validate_presence_of :loan_product_id }
      it { is_expected.to validate_presence_of :mode_of_payment }
      it { is_expected.to validate_presence_of :application_date }
      it { is_expected.to validate_presence_of :purpose }
      it { is_expected.to validate_numericality_of :loan_amount }
      it { is_expected.to validate_numericality_of :number_of_days }
    end 

    it "#process!" do 
      loan_officer          = create(:loan_officer)
      member                = create(:member)
      loan_product          = create(:loan_product)
      interest_config       = create(:interest_config, calculation_type: 'prededucted', rate: 0.12, loan_product: loan_product)
      interest_prededuction = create(:interest_prededuction, calculation_type: 'percent_based', rate: 1, loan_product: loan_product)
      office_loan_product = create(:office_loan_product, loan_product: loan_product, office: loan_officer.office)
      loan_aging_group    = create(:loan_aging_group, start_num: 0, end_num: 0, office: loan_officer.office)
      create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group, office_loan_product: office_loan_product)
      
      described_class.new(
        office_id:        loan_officer.office_id,
        cooperative_id:   loan_officer.cooperative_id,
        loan_product_id:  loan_product.id, 
        preparer_id:      loan_officer.id,
        borrower_id:      member.id,
        borrower_type:    member.class.to_s,
        loan_amount:      100_000,
        number_of_days:   365,
        application_date: Date.current, 
        account_number:   SecureRandom.uuid,
        mode_of_payment: 'monthly',
        purpose:         'Salary Loan'
      ).process!

      puts LoansModule::LoanApplication.count 
    end 
  end 
end 