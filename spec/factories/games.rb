FactoryBot.define do
  factory :game do
    title { 'MyString' }
    description { 'MyText' }
    game_url { 'MyString' }
    source_attribution { 'MyString' }
    published { false }
  end
end
