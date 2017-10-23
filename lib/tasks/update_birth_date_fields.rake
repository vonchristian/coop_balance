desc "Updating birth dates from date of birth"
task :update_birth_date_fields => :environment do
  puts "Updating birth dates from date of birth"
  
  Member.where('date_of_birth is not null').each do |u|
    u.birth_month = u.date_of_birth.month
    u.birth_day = u.date_of_birth.day
    u.save
  end

  puts "Finished updating birth dates from date of birth"
end