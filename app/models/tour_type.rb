class TourType < ApplicationRecord
  has_many :tours, dependent: :destroy
  has_ancestry
end
