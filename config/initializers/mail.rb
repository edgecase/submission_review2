ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'conference@scottishrubyconference.com',
  :password       => 'is-oas-jeb-yac',
  :domain         => 'scottishrubyconference.com'
}
ActionMailer::Base.delivery_method = :smtp
