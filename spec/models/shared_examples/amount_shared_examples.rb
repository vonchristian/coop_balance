shared_examples_for 'a AccountingModule::Amount subtype' do |elements|
  subject { amount }

  let(:amount) { build(elements[:kind]) }

  it { should be_valid }

  it 'requires an amount' do
    amount.amount_cents = nil
    expect(amount).not_to be_valid
  end

  it 'requires a entry' do
    amount.entry = nil
    expect(amount).not_to be_valid
  end

  it 'requires an account' do
    amount.account = nil
    expect(amount).not_to be_valid
  end
end
