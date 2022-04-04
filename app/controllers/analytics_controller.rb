class AnalyticsController < ApplicationController
  before_action :validate_params

  def index
    requests = TreasureHunts::TreasureHuntService.new.filter(params: permitted_params)
    render json: { status: "ok", requests: requests }, status: :ok
  end

  def permitted_params
    { start_time: parse_date(params[:start_time].first), end_time: parse_date(params[:end_time]), radius: params[:radius] }
  end

  def validate_params
    error_response = { status: "error", distance: -1 }
    render json: error_response.merge!(error_description: "start_time or end_time is empty"), status: :unprocessable_entity and return if params[:start_time].blank? || params[:end_time].blank?
    parsed_start_time = parse_date(params[:start_time].first)
    error_message = []
    error_message << "invalid time" if params[:start_time].present? && parsed_start_time == false
    error_message << "invalid time" if parsed_start_time > DateTime.current
    error_message << "invalid time" if params[:end_time].present? && parse_date(params[:end_time]) == false
    render json: error_response.merge!(error_description: error_message.join(", ")), status: :unprocessable_entity if error_message.length > 0
  end

  def parse_date(date)
    begin
       DateTime.parse(date)
    rescue
       false
    end
  end
end
