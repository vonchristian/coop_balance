class ChangePrincipalToMoneyCentsInAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    change_table :products do |t|
      t.monetize :principal
      t.monetize :interest
    end
  end
end
