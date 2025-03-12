TextNormalizer = Struct.new(:text, keyword_init: true) do
  def propercase
    text.split.map { |a| a.strip.capitalize }.join(" ")
  end
end
