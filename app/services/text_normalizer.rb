TextNormalizer = Struct.new(:text, keyword_init: true) do

  def propercase
    text.split.map{|a| a.lstrip.rstrip.capitalize }.join(" ")
  end
end
