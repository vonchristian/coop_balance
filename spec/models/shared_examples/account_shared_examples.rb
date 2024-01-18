shared_examples_for 'a AccountingModule::Account subtype' do |elements|
  subject { account }

  let(:contra) { false }
  let(:account) { create(elements[:kind], contra: contra) }

  describe 'class methods' do
    subject { account.class }

    describe 'trial_balance' do
      it 'raises NoMethodError' do
        expect { subject.trial_balance }.to raise_error NoMethodError
      end
    end
  end

  describe 'instance methods' do
    it 'reports a balance with date range' do
      expect(account.balance(from_date: '2014-01-01', to_date: Time.zone.today)).to be 0
    end

    it { should respond_to(:credit_entries) }
    it { should respond_to(:debit_entries) }
  end

  it 'requires a name' do
    account.name = nil
    expect(account).not_to be_valid
  end

  # Figure out which way credits and debits should apply
  :>
if elements[:normal_balance] == :debit  else  end
:<

  describe 'when given a debit' do
    before { create(:debit_amount, account: account) }

    describe 'on a contra account' do
      let(:contra) { true }
    end
  end

  describe 'when given a credit' do
    before { create(:credit_amount, account: account) }

    describe 'on a contra account' do
      let(:contra) { true }
    end
  end
end
