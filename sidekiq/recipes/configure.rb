include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "#{deploy[:deploy_to]}/shared/config/sidekiq.yml" do
    source "sidekiq.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(
      :sidekiq => deploy[:sidekiq] || {},
      :environment => deploy[:rails_env]
    )

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end

