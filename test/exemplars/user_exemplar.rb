class User < ActiveRecord::Base
  generator_for :email, :start=>'bob@example.com' do |prev|
    prev_first = prev.split('@').first
    "#{prev_first}@example.com"
  end
  
  generator_for :first_name, :start => 'Bob' do |prev|
    prev.succ
  end

  generator_for :last_name , :start=> 'Fish' do |prev|
    prev.succ
  end

  generator_for(:crypted_password) {'mavis'}
  generator_for(:password_salt){'fred'}
  generator_for(:persistence_token){'rita'}
  generator_for(:single_access_token){'sue'}
  generator_for(:perishable_token){"bob"}

end
