require 'rails_helper'

describe TextNormalizer do
  it { expect(TextNormalizer.new(text: " puhot").normalize).to eql "Puhot" }
  it { expect(TextNormalizer.new(text: "dad-an ").normalize).to eql "Dad-an" }
  it { expect(TextNormalizer.new(text: "mary ann ").normalize).to eql "Mary Ann" } 


end
