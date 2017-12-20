class Laborer < ApplicationRecord
  has_many :days_worked
  def full_name
    [first_name, last_name].join(" ")
  end
end
