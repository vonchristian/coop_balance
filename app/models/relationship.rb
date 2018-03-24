class Relationship < ApplicationRecord
  enum relationship_type: [:father, :mother, :son, :daughter]
  belongs_to :relationee, polymorphic: true
  belongs_to :relationer, polymorphic: true

  validates :relationee_id, :relationer_id, :relationer_type, :relationship_type, presence: true

  delegate :name, to: :relationer, prefix: true, allow_nil: true
  delegate :name, to: :relationee, prefix: true, allow_nil: true
  def self.for(relationer)
    relation = where(relationer: relationer).first.try(:relationship_type)
  end
  def self.fathers
    where(relationship_type: 'father')
  end
  def self.mothers
    where(relationship_type: 'mother')
  end
end
