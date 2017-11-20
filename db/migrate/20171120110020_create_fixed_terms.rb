class CreateFixedTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :fixed_terms, id: :uuid do |t|
      t.belongs_to :time_deposit, foreign_key: true, type: :uuid
      t.datetime :deposit_date
      t.datetime :maturity_date
      t.integer :number_of_days

      t.timestamps
    end
  end
end
