if Rails.env == "production"
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => 'admin@scotlandjs.com',
    :password       => 'is-oas-jeb-yac',
    :domain         => 'scotlandjs.com'
  }
  ActionMailer::Base.delivery_method = :smtp
end
