# require 'csv'
# namespace :import_members_csv do
#   task :create_members [:filename] => :environment do
#     CSV.foreach(filename, :headers => true) do |row|
#       Member.create!(row.to_hash)
#     end
#   end
# end 