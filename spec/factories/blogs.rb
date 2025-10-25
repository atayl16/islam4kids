FactoryBot.define do
  factory :blog do
    title { 'MyString' }
    content { 'MyText' }
    status { 'draft' }
  end
end
