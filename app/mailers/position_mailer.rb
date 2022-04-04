class PositionMailer < ApplicationMailer

  def treasure_found(distance, email)
    @email = email
    @count = TreasureHunts::TreasureHuntService.new.found_treasures_count.to_i + 1
    mail(to: email, subject: 'Treasure found')
  end
end
