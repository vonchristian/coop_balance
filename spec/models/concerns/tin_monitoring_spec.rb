require 'rails_helper'

describe TinMonitoring do
  extend TinMonitoring
  it '.with_tin' do
    member_with_tin    = create(:member)
    member_with_no_tin = create(:member)
    tin = create(:tin, tinable: member_with_tin)

    expect(Member.with_tin).to include(member_with_tin)
    expect(Member.with_tin).to_not include(member_with_no_tin)
  end

  it '.with_no_tin' do
    member_with_tin    = create(:member)
    member_with_no_tin = create(:member)
    tin = create(:tin, tinable: member_with_tin)

    expect(Member.with_no_tin).to include(member_with_no_tin)
    expect(Member.with_no_tin).to_not include(member_with_tin)
  end
end
