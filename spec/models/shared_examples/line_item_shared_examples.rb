shared_examples_for 'a StoreFrontModule::LineItem subtype' do |elements|
  let(:line_item) { create(elements[:kind])}
  subject { line_item }


end
