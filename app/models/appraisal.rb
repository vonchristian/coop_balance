class Appraisal < ApplicationRecord
  belongs_to :real_property
  belongs_to :appraiser, class_name: 'User', foreign_key: 'appraiser_id'
end
