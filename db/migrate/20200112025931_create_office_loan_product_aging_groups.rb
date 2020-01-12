class CreateOfficeLoanProductAgingGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :office_loan_product_aging_groups, id: :uuid do |t|
      t.belongs_to :office_loan_product, null: false, foreign_key: true, type: :uuid, index: { name: 'index_office_loan_products_on_office_loan_product_aging_groups' }
      t.belongs_to :loan_aging_group, null: false, foreign_key: true, type: :uuid, index: { name: 'index_loan_aging_groups_on_office_loan_product_aging_groups' }
      t.belongs_to :level_one_account_category, null: false, foreign_key: true, type: :uuid, index: { name: 'index_account_categories_on_office_loan_product_aging_groups' }

      t.timestamps
    end
  end
end
