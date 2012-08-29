ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.yandex.ru",
  :port                 => 587,
  :domain               => "goodmonday.ru",
  :user_name            => "robot@goodmonday.ru",
  :password             => "uPg5kZ6J7D",
  :authentication       => :plain,
  :enable_starttls_auto => false,
  :tsl                  => true
}