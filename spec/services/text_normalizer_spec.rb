require 'rails_helper'

describe TextNormalizer do
  it { expect(TextNormalizer.new(text: " puhot").propercase).to eql "Puhot" }
  it { expect(TextNormalizer.new(text: "dad-an ").propercase).to eql "Dad-an" }
  it { expect(TextNormalizer.new(text: "mary ann ").propercase).to eql "Mary Ann" }
  it { expect(TextNormalizer.new(text: "VEVERLY MARCOS").propercase).to eql "Veverly Marcos" } 



end
