class FinishedGoodForm
  include ActiveModel::Model
  attr_accessor :unit_cost, :total_cost, :quantity, :recorder_id, :raw_material_id, :date

  def save
    ActiveRecord::Base.transaction do
      create_finished_goods
      create_entry
    end
  end

  def create_finished_goods
    FinishedGoodMaterial.create(unit_cost: unit_cost, raw_material_id: raw_material_id, total_cost: total_cost, date:date)
  end
  def find_finished_good
    FinishedGoodMaterial.find_by(unit_cost: unit_cost, raw_material_id: raw_material_id, total_cost: total_cost, date:date)
  end
  def create_entry
    AccountingDepartment::Entry.create!(entry_type: 'finished_good_entry', entry_date: date, description: "Entry on finished_goods", debit_amounts_attributes: [amount: find_finished_good.total_cost, account: AccountingDepartment::Account.find_by(name: "Finished Goods Inventory")], credit_amounts_attributes:[amount: find_finished_good.total_cost, account: AccountingDepartment::Account.find_by(name: 'Work in Process Inventory')],  recorder_id: recorder_id)
  end
end
