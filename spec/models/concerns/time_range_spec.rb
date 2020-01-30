require 'rails_helper'

describe TimeRange do 
  describe "#start_time" do 
    it "returns from_time if is_a?(Time)" do 
   
      expect(TimeRange.new(from_time: Time.zone.now, to_time: Time.zone.now.end_of_day).start_time.strftime('%-l:%M %p')).to eql(Time.zone.now.strftime('%-l:%M %p'))
    end 
  end 
end 