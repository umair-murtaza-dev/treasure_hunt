require 'faker'

FactoryBot.define do

  factory :treasure_hunt, :class => TreasureHunts::TreasureHunt do
    distance {4}
    current_location { ["0", "0"]}
    email {"test@xyz.com"}
  end
  #
  # factory :subscription, :class => Subscriptions::Subscription  do
  #   account_name {Faker::Name.name}
  #   account_id { '096dbece-f82e-11e8-809b-0252151e4411' }
  #   charging_id {Faker::Number.number(digits: 2)}
  #   plan_id {Faker::Number.number(digits: 2)}
  #   charging_month {Faker::Number.number(digits: 2)}
  #   per_unit_verifications {Faker::Number.decimal(l_digits: 2)}
  # end
  #
  # factory :generic_sender_id, :class => GenericSenderIds::GenericSenderId  do
  #   sender_id { 'sampleid' }
  #   activated { true }
  # end
  #
  # factory :app_user, :class => Apps::Users::AppUser  do
  #   channel_id {1}
  #   address { "+9232100000" }
  # end
  #
  # factory :sms_app_user, :class => Apps::Users::AppUser  do
  #   channel_id {1}
  #   address { "+9232100000" }
  # end
  #
  # factory :voice_app_user, :class => Apps::Users::AppUser  do
  #   channel_id { 2 }
  #   address { "+9232100000" }
  # end
  #
  # factory :whatsapp_app_user, :class => Apps::Users::AppUser  do
  #   channel_id { 3 }
  #   address { "+9232100000" }
  # end
  #
  #
  # factory :verification, :class => Verifications::Verification do
  #   generated_code { "1234" }
  #   status { :pending }
  #   uuid { "1234" }
  #   code_type_id { 1 }
  #   code_length { 4 }
  #   selected_locale_id { 2 }
  # end
end
