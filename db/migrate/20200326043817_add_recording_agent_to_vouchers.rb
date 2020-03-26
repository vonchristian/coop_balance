class AddRecordingAgentToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_reference :vouchers, :recording_agent, polymorphic: true, type: :uuid 
  end
end
