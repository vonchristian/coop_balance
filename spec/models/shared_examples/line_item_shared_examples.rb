shared_examples_for 'a StoreFrontModule::LineItem subtype' do |elements|
  let(:line_item) { create(elements[:kind])}
  subject { line_item }

  it "should require a purchase_line_item" do
    line_item.purchase_line_item = nil
    expect(line_item).to_not be_valid
  end
end
