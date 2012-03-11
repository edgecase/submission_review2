require 'factory_girl_rails'

FactoryGirl.define do

  sequence(:twitter) { |n| "loginname#{n}" }

  factory :reviewer do |f|
    f.twitter               { Factory.next(:twitter) }
  end

  factory :proposal do |f|
    %w(title abstract description).each do |attr|
      sequence(attr){|n| "#{attr}#{n}"}
    end
  end

  factory :rating do |f|
    f.association           :proposal
    f.association           :reviewer
    f.score                 1
  end

  factory :user do
    sequence(:email) {|n| "bob#{n}@example.com"}
    %w(first_name last_name).each do |attr|
      sequence(attr){|n| "#{attr}#{n}"}
    end
  end
end
