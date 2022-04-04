require 'rails_helper'

describe 'TreasureHunt API', type: :request do
  let!(:treasure_hunt) { FactoryBot.create(:treasure_hunt) }

  describe '#analytics' do
    it 'should return missing time error' do
      get '/analytics.json', params: {radius: 10}
      response_body = JSON.parse(response.body)
      expect(response_body["status"]).to eq("error")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should return invalid time error' do
      get '/analytics.json', params: {start_time: [DateTime.current + 1.day], end_time: DateTime.current, radius: 10}
      response_body = JSON.parse(response.body)
      expect(response_body["status"]).to eq("error")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should return record' do
      get '/analytics.json', params: {start_time: [DateTime.current - 1.day], end_time: DateTime.current, radius: 10}
      response_body = JSON.parse(response.body)
      expect(response_body["status"]).to eq("ok")
      expect(response).to have_http_status(:success)
    end
  end
end
