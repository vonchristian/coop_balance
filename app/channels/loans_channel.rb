class LoansChannel < ApplicationCable::Channel
  def subscribed
    stream_from "loans_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
