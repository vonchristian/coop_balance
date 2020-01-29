class HardWorker 
  include Sidekiq::Worker 

  def perform(name, count)
    puts 'doooo'
  end 
end 