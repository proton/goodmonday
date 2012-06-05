ActionMailer::Base.smtp_settings = {  
	:address              => "smtp.yandex.ru",  
	:port                 => 587,  
	:domain               => "goodmonay.ru",
	:user_name            => "robot@goodmonay.ru",
	:password             => "cWOHc1U9",
	:authentication       => :plain,  
	:enable_starttls_auto => false,
	:tsl                  => true
}