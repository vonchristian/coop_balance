require 'rails_helper'

module AccountingModule
  describe Entry do
  	describe 'associations' do
      it { is_expected.to have_one :voucher }
      it { is_expected.to belong_to :official_receipt }
      it { is_expected.to belong_to :previous_entry }
  		it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :cooperative_service }
      it { is_expected.to belong_to :cancelled_by }
      it { is_expected.to belong_to :recorder }

      it { is_expected.to have_many :referenced_entries }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :debit_accounts }
      it { is_expected.to have_many :credit_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :amounts }
  	end

    describe 'validations' do
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :previous_entry_id }
      it { is_expected.to validate_presence_of :recorder_id }
      it { is_expected.to validate_presence_of :office_id }
      it { is_expected.to validate_presence_of :cooperative_id }

      it '#has_credit_amounts?' do
        entry = build(:entry)
        credit_amount = build(:credit_amount, entry: entry)
        entry.save

        expect(entry).to_not be_valid
      end

      it '#has_debit_amounts?' do
        entry = build(:entry)
        debit_amount = build(:debit_amount, entry: entry, amount: 100)
        entry.save

        expect(entry).to_not be_valid
      end

      it "#amounts_cancel?" do
        cooperative = create(:cooperative)
        employee = create(:user, role: 'teller', cooperative: cooperative)
        cash_on_hand = create(:asset, name: "Cash on Hand")
        revenue = create(:revenue)
        deprecation = create(:asset)
        property = create(:asset)
        employee.cash_accounts << cash_on_hand

        entry = build(:entry, cooperative: cooperative)
        entry.debit_amounts.build(account: cash_on_hand)
        entry.credit_amounts.build(account: revenue)
        entry.save!

        expect(entry).to be_valid


      end

    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:name).to(:commercial_document).with_prefix }
      it { is_expected.to delegate_method(:title).to(:cooperative_service).with_prefix }
    end

    describe 'nested_attributes' do
      it { is_expected.to accept_nested_attributes_for(:debit_amounts) }
      it { is_expected.to accept_nested_attributes_for(:credit_amounts) }

    end

    it "#entries_present?" do
      cooperative = create(:cooperative)
      expect(cooperative.entries.exists?).to be false

      origin_entry = create(:origin_entry, cooperative: cooperative)

      expect(origin_entry.entries_present?).to eql true
    end

    it "#hashes_valid?" do
      date =  Date.today.strftime("%B %e, %Y")
      AccountingModule::Entry.destroy_all
      cooperative = create(:cooperative, id: '76b0ff55-2ede-45c1-87f9-c02ec497fe59')
      office = create(:office, cooperative: cooperative, id: '76b0ff55-2ede-45c1-87f9-c02ec497fe59')
      employee = create(:user, role: 'teller', cooperative:cooperative, id: '76b0ff55-2ede-45c1-87f9-c02ec497fe59')

      genesis_account = cooperative.accounts.assets.create(name: "Genesis Account", active: false, code: "Genesis Code")
      origin_entry = cooperative.entries.new(
      office:              office,
      cooperative:         cooperative,
      commercial_document: cooperative,
      description:         "Genesis entry",
      recorder:            employee,
      reference_number:    "Genesis",
      previous_entry_id:   "",
      previous_entry_hash:   "Genesis previous entry hash",
      encrypted_hash:      "Genesis encrypted hash",
      entry_date:         date)
      origin_entry.debit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: cooperative)
      origin_entry.credit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: cooperative)
      origin_entry.save!

      employee_cash_account = create(:employee_cash_account, employee: employee)
      saving = create(:saving, cooperative: cooperative, id: '76b0ff55-2ede-45c1-87f9-c02ec497fe59')

      deposit = build(:entry,
        office: office,
        cooperative: cooperative,
        recorder: employee,
        entry_date: date,
        created_at: date,
        updated_at: date,
        commercial_document: saving,
        previous_entry: origin_entry,
        previous_entry_hash: origin_entry.encrypted_hash)
      deposit.credit_amounts << build(:credit_amount, amount: 5_000, commercial_document: saving, account: saving.saving_product_account)
      deposit.debit_amounts << build(:debit_amount, amount: 5_000, commercial_document: saving, account: employee_cash_account.cash_account)
      deposit.save!

      expect(deposit.encrypted_hash).to eql Digest::SHA256.hexdigest(deposit.digestable)
    end

    context 'scopes' do
      it '.not_archived' do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative, created_at: Date.today.last_month)
        unarchived_entry = create(:entry_with_credit_and_debit, cooperative: cooperative, previous_entry: origin_entry, archived: false)
        archived_entry = create(:entry_with_credit_and_debit, cooperative: cooperative, previous_entry: unarchived_entry, archived: true)

        expect(described_class.not_archived).to include(unarchived_entry)
        expect(described_class.not_archived).to_not include(archived_entry)
      end

      it '.archived' do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative, created_at: Date.today.last_month)
        unarchived_entry = create(:entry_with_credit_and_debit, cooperative: cooperative, previous_entry: origin_entry, archived: false)
        archived_entry = create(:entry_with_credit_and_debit, cooperative: cooperative, previous_entry: unarchived_entry, archived: true)

        expect(described_class.archived).to include(archived_entry)
        expect(described_class.archived).to_not include(unarchived_entry)
      end

      it '.recent' do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative, created_at: Date.today.last_month)
        old_entry    = create(:entry_with_credit_and_debit, created_at: Date.today.yesterday, cooperative: cooperative, previous_entry: origin_entry)
        recent_entry = create(:entry_with_credit_and_debit, created_at: Date.today, previous_entry: old_entry, cooperative: cooperative)

        expect(described_class.recent).to eql recent_entry
        expect(described_class.recent).to_not eql old_entry
      end

      it '.not_cancelled' do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative, created_at: Date.today.last_month)
        entry = create(:entry_with_credit_and_debit, cancelled: false, cooperative: cooperative, previous_entry: origin_entry)
        cancelled_entry = create(:entry_with_credit_and_debit, cancelled: true, cancelled_at: Date.today, cancellation_description: 'wrong entry', previous_entry: entry, cooperative: cooperative)

        expect(described_class.not_cancelled).to include(entry)
        expect(described_class.not_cancelled).to_not include(cancelled_entry)
      end

      it '.cancelled' do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative, created_at: Date.today.last_month)
        not_cancelled_entry = create(:entry_with_credit_and_debit, cancelled: false, cooperative: cooperative, previous_entry: origin_entry)
        cancelled_entry = create(:entry_with_credit_and_debit, cancelled: true, cancelled_at: Date.today, cancellation_description: 'wrong entry', previous_entry: not_cancelled_entry, cooperative: cooperative)

        expect(described_class.cancelled).to_not include(not_cancelled_entry)
        expect(described_class.cancelled).to include(cancelled_entry)
      end

      it '.recorder_by(args={})' do
        cooperative = create(:cooperative)
        teller = create(:teller)
        bookkeeper = create(:bookkeeper)
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry = create(:entry_with_credit_and_debit, recorder: teller, cooperative: cooperative, previous_entry: origin_entry)
        another_entry = create(:entry_with_credit_and_debit, recorder: bookkeeper, cooperative: cooperative, previous_entry: entry)

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
    it '.without_cash_accounts' do
      cooperative = create(:cooperative)
      employee = create(:user, role: 'teller', cooperative: cooperative)
      cash_on_hand = create(:asset, name: "Cash on Hand")
      revenue = create(:revenue)
      deprecation = create(:asset)
      property = create(:asset)
      employee.cash_accounts << cash_on_hand

      entry_with_cash_account = build(:entry, cooperative: cooperative)
      entry_with_cash_account.debit_amounts.build(account: cash_on_hand)
      entry_with_cash_account.credit_amounts.build(account: revenue)
      entry_with_cash_account.save

      entry_without_cash_account = build(:entry, cooperative: cooperative, previous_entry: entry_with_cash_account)
      entry_without_cash_account.debit_amounts.build(account: deprecation)
      entry_without_cash_account.credit_amounts.build(account: property)
      entry_without_cash_account.save

      expect(described_class.without_cash_accounts).to include(entry_without_cash_account)
      expect(described_class.without_cash_accounts).to_not include(entry_with_cash_account)

    end
  end
end
