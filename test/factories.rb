Factory.sequence(:twitter) { |n| "loginname#{n}" }

Factory.define :reviewer do |f|
  f.twitter               { Factory.next(:twitter) }
end

Factory.define :proposal do |f|
  f.title                 'example'
end

Factory.define :rating do |f|
  f.association           :proposal
  f.association           :reviewer
  f.score                 1
end