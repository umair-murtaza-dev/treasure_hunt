require 'rails_helper'


RSpec.describe 'TreasureHunt Service', type: :model do
  let!(:treasure_hunt) { FactoryBot.create(:treasure_hunt) }

  describe '#found_treasures_count' do
    it 'should return count of treasures within 5m distance' do
      hunt = TreasureHunts::TreasureHuntService.new.found_treasures_count
      expect(hunt).to eq(1)
    end
  end

  describe '#calculate_distance' do
    it 'should calculate distance' do
      distance = TreasureHunts::TreasureHuntService.new.calculate_distance(current_location: ["0", "0"], email: "test@xyz.com")
      expect(distance).to eq(5879185.36957994)
    end
  end


  describe '#filter' do
    let!(:treasure_hunt) { FactoryBot.create(:treasure_hunt) }
    it 'should return requests within distance' do
      criteria = {radius: 10}
      requests = TreasureHunts::TreasureHuntService.new.filter(params: criteria)
      expect(requests.length).to eq(1)
    end
  end
end
