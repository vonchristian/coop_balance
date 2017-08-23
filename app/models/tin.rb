class Tin < ApplicationRecord
  belongs_to :tinable, polymorphic: true
end
