define :opsworks_rails do
  deploy = params[:deploy_data]
  application = params[:app]

  include_recipe node[:opsworks][:rails_stack][:recipe]

  # write out memcached.yml
  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    cookbook "rails"
    source "memcached.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => (deploy[:memcached] || {}), :environment => deploy[:rails_env])

    only_if do
      deploy[:memcached] && deploy[:memcached][:host].present?
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    cookbook "rails"
    source "redis.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:redis => (deploy[:redis] || {}), :environment => deploy[:rails_env])

    only_if do
      deploy[:redis] && deploy[:redis][:host].present?
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/sidekiq.yml" do
    source "sidekiq.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:sidekiq => deploy[:sidekiq] || {}, :environment => deploy[:rails_env])

    only_if do
      deploy[:sidekiq] && deploy[:sidekiq][:enabled] == true
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source "secrets.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:secrets => deploy[:secrets], :environment => deploy[:rails_env])

    only_if do
      deploy[:secrets]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/settings.local.yml" do
    source "settings.local.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:secrets => deploy[:secrets], :environment => deploy[:rails_env])

    only_if do
      deploy[:secrets]
    end

  end

  template "#{deploy[:deploy_to]}/shared/config/newrelic.yml" do
    source "newrelic.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:newrelic => deploy[:newrelic], :environment => deploy[:rails_env])

    only_if do
      deploy[:newrelic]
    end

  end

  directory "#{deploy[:deploy_to]}/shared/config/initializers" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/smtp.rb" do
    source "smtp.rb.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:smtp => deploy[:smtp] || {}, :environment => deploy[:rails_env])

    only_if do
      deploy[:smtp]
    end

  end


  execute "symlinking subdir mount if necessary" do
    command "rm -f /var/www/#{deploy[:mounted_at]}; ln -s #{deploy[:deploy_to]}/current/public /var/www/#{deploy[:mounted_at]}"
    action :run
    only_if do
      deploy[:mounted_at] && File.exists?("/var/www")
    end
  end

end

