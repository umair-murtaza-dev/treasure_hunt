class TreasureHunts::TreasureHuntService

  def found_treasures_count
    TreasureHunts::TreasureHunt.where('distance <=  ?', 5 ).count
  end

  def filter(params:)
    hunt_requests = TreasureHunts::TreasureHunt.where(nil)
    hunt_requests = hunt_requests.within_time(params[:start_time], params[:end_time]) if params[:start_time] && params[:end_time]
    hunt_requests = hunt_requests.within_radius(params[:radius]) if params[:radius]
    hunt_request_presenter(hunt_requests)
  end

  def calculate_distance(current_location:, email:)
    @treasure_location = TreasureHunts::TreasureHunt.treasure_location.tr('aA-zZ ', '').split(",")
    begin
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                                                     # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlat_rad = (@treasure_location[0].to_f-current_location[0].to_f) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (@treasure_location[1].to_f-current_location[1].to_f) * rad_per_deg

      lat1_rad, lon1_rad = current_location.map {|i| i.to_f * rad_per_deg }
      lat2_rad, lon2_rad = @treasure_location.map {|i| i.to_f * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
      distance = rm * c # Delta in meters
      save_request(current_location, email, distance)
      PositionMailer.treasure_found(distance, email).deliver_now if distance.to_i < 5
      distance
    rescue
      Errors::Error.new.message
    end
  end

  private

  def hunt_request_presenter(hunt_requests) # Build json response
    return [] unless hunt_requests.any?
    requests_dto = []
    hunt_requests.each do |request|
      requests_dto << {
        distance: request.distance,
        email: request.email,
        current_location: request.current_location
      }
    end
    requests_dto
  end

  def save_request(current_location, email, distance)
    TreasureHunts::TreasureHunt.create(
      distance: distance,
      email: email,
      current_location: current_location
    )
  end
end
