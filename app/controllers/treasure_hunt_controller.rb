class TreasureHuntController < ApplicationController
  before_action :validate_params

  def create
    distance = TreasureHunts::TreasureHuntService.new.calculate_distance(current_location: params[:current_location], email: params[:email])
    if distance.is_a?(Hash)
      render json: distance, status: :unprocessable_entity
    else
      render json: { status: "ok", distance: distance.to_i }, status: :ok
    end
  end

  private

  def validate_params
    error_response = { status: "error", distance: -1 }
    error_message = []
    error_message << "current location not found" unless params[:current_location]
    error_message << "email not found" unless params[:email]
    error_message << "current location is invalid" if params[:current_location] && params[:current_location].length < 2
    render json: error_response.merge!(error_description: error_message.join(", ")), status: :unprocessable_entity if error_message.length > 0
  end
end
