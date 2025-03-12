class CreateDocumentaryStampTaxes < ActiveRecord::Migration[5.1]
  def change
    create_table :documentary_stamp_taxes, id: :uuid do |t|
      t.references :taxable, polymorphic: true

      t.timestamps
    end
  end
end
