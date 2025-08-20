FactoryBot.define do
  factory :pet do
    sequence(:owner_id) { |n| n }
    tracker_type { %w[small big medium].sample }
    in_zone { [ true, false ].sample }
    lost_tracker { false }

    trait :in_zone do
      in_zone { true }
    end

    trait :outside_zone do
      in_zone { false }
    end

    trait :with_lost_tracker do
      lost_tracker { true }
    end
  end

  factory :cat, parent: :pet, class: "Cat" do
    type { "Cat" }
    tracker_type { %w[small big].sample }
    lost_tracker { [ true, false ].sample }

    trait :small_tracker do
      tracker_type { "small" }
    end

    trait :big_tracker do
      tracker_type { "big" }
    end

    trait :with_tracker do
      lost_tracker { false }
    end

    trait :with_lost_tracker do
      lost_tracker { true }
    end
  end

  factory :dog, parent: :pet, class: "Dog" do
    type { "Dog" }
    tracker_type { %w[small medium big].sample }
    lost_tracker { false }

    trait :small_tracker do
      tracker_type { "small" }
    end

    trait :medium_tracker do
      tracker_type { "medium" }
    end

    trait :big_tracker do
      tracker_type { "big" }
    end
  end
end
