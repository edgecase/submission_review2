require 'factory_girl_rails'

FactoryGirl.define do

  sequence(:twitter) { |n| "loginname#{n}" }

  factory :reviewer do |f|
    f.twitter               { Factory.next(:twitter) }
  end

  factory :proposal do |f|
    %w(title reviewer_notes description).each do |attr|
      sequence(attr){|n| "#{attr}#{n}"}
    end
  end

  factory :rating do |f|
    f.association           :proposal
    f.association           :reviewer
    f.score                 1
  end

  factory :presenter do
    %w(full_name email).each do |attr|
      sequence(attr){|n| "#{attr}#{n}"}
    end
  end
end
