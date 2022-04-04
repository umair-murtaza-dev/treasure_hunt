require 'rails_helper'

describe 'TreasureHunt API', type: :request do
  let!(:treasure_hunt) { FactoryBot.create(:treasure_hunt) }

  describe '#create' do
    it 'calculate distance for a request' do
      post '/treasure_hunt.json', params: {current_location: ["0", "0"], email: "test@xyz.com"}
      response_body = JSON.parse(response.body)
      expect(response_body["status"]).to eq("ok")
      expect(response).to have_http_status(:success)
    end

    it 'should return error for empty current location' do
      post '/treasure_hunt.json', params: { email: "test@xyz.com"}
      response_body = JSON.parse(response.body)
      expect(response_body["status"]).to eq("error")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
