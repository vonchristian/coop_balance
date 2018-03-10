def post_quarterly_interests
      subscribers.with_minimum_balances.each do |saving|
        if !saving.interest_posted?(Time.zone.now.end_of_quarter)
          InterestPosting.new.post_interests_earned(saving, Time.zone.now.end_of_quarter)
        end
      end
end
