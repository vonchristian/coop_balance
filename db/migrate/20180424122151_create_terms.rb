class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms, id: :uuid do |t|
      t.references :termable, polymorphic: true
      t.datetime :effectivity_date
      t.datetime :maturity_date
      t.integer :term

      t.timestamps
    end
  end
end
