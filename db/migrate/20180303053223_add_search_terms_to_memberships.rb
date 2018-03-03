class AddSearchTermsToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :search_term, :string
  end
end
