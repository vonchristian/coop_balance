class TinVerifier
  attr_reader :tin
  def initialize(args)
    @tin = args.fetch(:tin)
  end
  def verified?
    true
  end
end 
