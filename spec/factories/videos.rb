FactoryBot.define do
  factory :video do
    sequence(:title) { |n| "Test Video #{n}" }
    description { 'A description about this video' }
    video_url { 'https://youtu.be/WZk197Rf5LQ' }
    featured { false }
    status { 'draft' }
    position { 0 }

    trait :published do
      status { 'published' }
    end

    trait :featured do
      featured { true }
    end

    trait :archived do
      status { 'archived' }
    end
  end
end
