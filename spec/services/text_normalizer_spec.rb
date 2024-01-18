require 'rails_helper'

describe TextNormalizer do
  it { expect(described_class.new(text: ' puhot').propercase).to eql 'Puhot' }
  it { expect(described_class.new(text: 'dad-an ').propercase).to eql 'Dad-an' }
  it { expect(described_class.new(text: 'mary ann ').propercase).to eql 'Mary Ann' }
  it { expect(described_class.new(text: 'VEVERLY MARCOS').propercase).to eql 'Veverly Marcos' }
end
