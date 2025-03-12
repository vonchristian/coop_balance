class AddRecordingAgentToEntries < ActiveRecord::Migration[6.0]
  def change
    add_reference :entries, :recording_agent, polymorphic: true, type: :uuid
  end
end
