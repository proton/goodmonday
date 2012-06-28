CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAISUPHX6DDALNHMBQ',
    :aws_secret_access_key  => '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',
    :region                 => 'eu-west-1'
  }
  config.fog_directory  = 'ext.goodmonday.ru'
  config.fog_host       = 'http://ext.goodmonday.ru'
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end