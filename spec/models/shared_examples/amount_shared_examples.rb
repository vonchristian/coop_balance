shared_examples_for 'a AccountingModule::Amount subtype' do |elements|
  let(:amount) { FactoryBot.build(elements[:kind]) }
  subject { amount }

  it { is_expected.to be_valid }

  it "should require an amount" do
    amount.amount = nil
    expect(amount).to_not be_valid
  end

  it "should require a entry" do
    amount.entry = nil
    expect(amount).to_not be_valid
  end

  it "should require an account" do
    amount.account = nil
    expect(amount).to_not be_valid
  end
  it "should require a commercial_document" do
    amount.commercial_document = nil
    expect(amount).to_not be_valid
  end
end
