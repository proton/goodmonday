$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Для работы rvm
require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.

set :application, "cpa"
set :rails_env, "production"
set :domain, "www@vsestulya.ru" # Это необходимо для деплоя через ssh. Именно ради этого я настоятельно советовал сразу же залить на сервер свой ключ, чтобы не вводить паролей.
set :port, 2323
set :deploy_to, "/var/www/rails/#{application}"
set :use_sudo, false

set :rvm_ruby_string, '1.9.3-p125' # Это указание на то, какой Ruby интерпретатор мы будем использовать.
set :rvm_type, :user # Указывает на то, что мы будем использовать rvm, установленный у пользователя, от которого происходит деплой, а не системный rvm.

set :scm, :git # Используем git. Можно, конечно, использовать что-нибудь другое - svn, например, но общая рекомендация для всех кто не использует git - используйте git.
set :repository,  "git@bitbucket.org:proton/cpa.git"
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

#after 'deploy:update_code', :roles => :app do
#	# Здесь для примера вставлен только один конфиг с приватными данными - database.yml. Обычно для таких вещей создают папку /srv/myapp/shared/config и кладут файлы туда. При каждом деплое создаются ссылки на них в нужные места приложения.
#	#run "rm -f #{current_release}/config/mongoid.yml"
#	#run "ln -s #{deploy_to}/shared/config/mongoid.yml #{current_release}/config/mongoid.yml"
#end

## Далее идут правила для перезапуска unicorn. Их стоит просто принять на веру - они работают.
#namespace :deploy do
#	task :restart do
#		run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
#	end
#	task :start do
#		run "bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
#	end
#	task :stop do
#		run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
#	end
#end

namespace :deploy do
  task :start do
    sudo "/etc/init.d/thin.#{application} start"
  end
  task :stop do
    sudo "/etc/init.d/thin.#{application} stop"
  end
  task :restart do
    sudo "/etc/init.d/thin.#{application} reload"
  end
end