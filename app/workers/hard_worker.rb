class HardWorker
  include Sidekiq::Worker

  def perform(_name, _count)
    Rails.logger.debug 'doooo'
  end
end