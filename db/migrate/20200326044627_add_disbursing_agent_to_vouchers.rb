class AddDisbursingAgentToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_reference :vouchers, :disbursing_agent, polymorphic: true,type: :uuid 
  end
end
