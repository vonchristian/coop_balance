class Relationship < ApplicationRecord
  enum :relationship_type, { father: 0, mother: 1, son: 2, daughter: 3 }
  belongs_to :relationee, polymorphic: true
  belongs_to :relationer, polymorphic: true

  validates :relationer_type, :relationship_type, presence: true

  delegate :name, to: :relationer, prefix: true, allow_nil: true
  delegate :name, to: :relationee, prefix: true, allow_nil: true
  def self.for(relationer)
    where(relationer: relationer).first.try(:relationship_type)
  end

  def self.fathers
    where(relationship_type: "father")
  end

  def self.mothers
    where(relationship_type: "mother")
  end
end
