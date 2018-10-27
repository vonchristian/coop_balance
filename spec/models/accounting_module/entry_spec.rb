require 'rails_helper'

module AccountingModule
  describe Entry do
  	describe 'associations' do
  		it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :cancelled_by }
      it { is_expected.to belong_to :recorder }

      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :debit_accounts }
      it { is_expected.to have_many :credit_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :amounts }
  	end

    describe 'validations' do
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :office_id }
      it { is_expected.to validate_presence_of :cooperative_id }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:name).to(:commercial_document).with_prefix }
    end

    context 'scopes' do
      it '.recent' do
        old_entry    = create(:entry_with_credit_and_debit, created_at: Date.today.yesterday)
        recent_entry = create(:entry_with_credit_and_debit, created_at: Date.today, previous_entry: old_entry)

        expect(described_class.recent).to eql recent_entry
        expect(described_class.recent).to_not eql old_entry
      end

      it '.not_cancelled' do
        entry = create(:entry_with_credit_and_debit, cancelled: false)
        cancelled_entry = create(:entry_with_credit_and_debit, cancelled: true, cancelled_at: Date.today, cancellation_description: 'wrong entry', previous_entry: entry)

        expect(described_class.not_cancelled).to include(entry)
        expect(described_class.not_cancelled).to_not include(cancelled_entry)
      end

      it '.recorder_by(args={})' do
        teller = create(:teller)
        bookkeeper = create(:bookkeeper)

        entry = create(:entry_with_credit_and_debit, recorder: teller)
        another_entry = create(:entry_with_credit_and_debit, recorder: bookkeeper, previous_entry: entry)

        expect(described_class.recorded_by(recorder: teller)).to include(entry)
        expect(described_class.recorded_by(recorder: teller)).to_not include(another_entry)

        expect(described_class.recorded_by(recorder: bookkeeper)).to include(another_entry)
        expect(described_class.recorded_by(recorder: bookkeeper)).to_not include(entry)

      end

    end

    context 'without credit and debit' do
      it 'is not valid' do
        entry = build(:entry)
        expect(entry).to_not be_valid
      end
    end

    context "with credit and debit" do
      it 'is valid' do
        entry = build(:entry_with_credit_and_debit)
        expect(entry).to be_valid
      end
    end


    context "with a debit" do
      let(:entry) { build(:entry)}

      it 'is not valid' do
        debit_amounts = build(:debit_amount, entry: entry)
        expect(entry).to_not be_valid
      end
      it 'is not valid with invalid debit amount' do
        debit_amounts = build(:debit_amount, entry: entry, amount: nil)
        expect(entry).to_not be_valid
      end
    end

    context "with a credit" do
      let(:entry) { build(:entry)}
      it 'is not valid' do
        credit_amounts = build(:credit_amount, entry: entry)
        expect(entry).to_not be_valid
      end

      it 'is not valid with invalid credits amount' do
        credit_amounts = build(:credit_amount, entry: entry, amount: nil)
        expect(entry).to_not be_valid
      end
    end

    context "without an entry date" do
      it "should assign a default date before being saved" do
        entry = create(:entry_with_credit_and_debit, entry_date: nil)
        entry.save
        expect(entry.entry_date.to_date).to eql Time.zone.now.to_date
      end
    end
    context 'debits and credits should cancel' do
      let(:entry) { build(:entry)}
      it "should require the debit and credit amounts to cancel" do
        entry.credit_amounts << build(:credit_amount, :amount => 100, :entry => entry)
        entry.debit_amounts << build(:debit_amount, :amount => 200, :entry => entry)
        expect(entry).to_not be_valid
        expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
      end

      it "should require the debit and credit amounts to cancel even with fractions" do
        entry = build(:entry)
        entry.credit_amounts << build(:credit_amount, :amount => 100.1, :entry => entry)
        entry.debit_amounts << build(:debit_amount, :amount => 100.2, :entry => entry)
        expect(entry).to_not be_valid
        expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
      end

      it "should ignore debit and credit amounts marked for destruction to cancel" do
        entry.credit_amounts << build(:credit_amount, :amount => 100, :entry => entry)
        debit_amount = build(:debit_amount, :amount => 100, :entry => entry)
        debit_amount.mark_for_destruction
        entry.debit_amounts << debit_amount
        expect(entry).to_not be_valid
        expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
      end
    end


    context "given a set of accounts" do
      let(:mock_document) { create(:asset) }
      let!(:accounts_receivable) { create(:asset, name: "Accounts Receivable") }
      let!(:sales_revenue) { create(:revenue, name: "Sales Revenue") }
      let!(:sales_tax_payable) { create(:liability, name: "Sales Tax Payable") }

      shared_examples_for 'a built-from-hash Accounting::Entry' do
        its(:credit_amounts) { is_expected.to_not be_empty }
        its(:debit_amounts) { is_expected.to_not be_empty }
        it { is_expected.to be_valid }

        context "when saved" do
          before { entry.save! }
          its(:id) { is_expected.to_not be_nil }

          context "when reloaded" do
            let(:saved_transaction) { Entry.find(entry.id) }
            subject { saved_transaction }
            it("should have the correct commercial document") {
              saved_transaction.commercial_document == mock_document
            }
          end
        end
      end
    end
  end
end
