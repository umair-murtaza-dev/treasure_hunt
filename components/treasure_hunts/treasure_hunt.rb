class TreasureHunts::TreasureHunt < ApplicationRecord

  scope :within_radius, ->(radius){ where('distance < ?', radius) }
  scope :within_time, ->(start_time, end_time) { where(created_at: start_time..end_time) }


  def self.treasure_location
    "50.051227 N, 19.945704 E"
  end
end
