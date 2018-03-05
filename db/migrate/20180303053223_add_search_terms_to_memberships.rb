class AddSearchTermsToMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :search_term, :string
  end
end
