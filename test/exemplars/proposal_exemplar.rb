class Proposal < ActiveRecord::Base
  
  generator_for :title, :start=>'proposal' do |prev|
    prev.succ
  end
  
  generator_for :abstract, :start=>'abstract' do |prev|
    prev.succ
  end

  generator_for :description, :start=>'description' do |prev|
    prev.succ
  end
  
end