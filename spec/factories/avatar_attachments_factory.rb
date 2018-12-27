FactoryBot.define do
  factory :attachment do
    item { File.new(Rails.root + 'spec/support/images/default.png') }
  end
end
