module Archiveable
  extend ActiveSupport::Concern
  included do
    has_one :archive, as: :record
  end
end
