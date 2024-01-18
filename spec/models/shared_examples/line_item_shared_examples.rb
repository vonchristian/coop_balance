shared_context 'a StoreFrontModule::LineItem subtype' do |elements|
  subject { line_item }

  let(:line_item) { create(elements[:kind]) }
end
