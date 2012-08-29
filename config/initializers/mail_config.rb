ActionMailer::Base.smtp_settings = {  
	:address              => "smtp.yandex.ru",  
	:port                 => 587,  
	:domain               => "goodmonay.ru",
	:user_name            => "robot@goodmonay.ru",
	:password             => "uPg5kZ6J7D",
	:authentication       => :plain,  
	:enable_starttls_auto => false,
	:tsl                  => true
}