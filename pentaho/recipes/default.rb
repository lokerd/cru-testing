bash "install_program" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget http://sourceforge.net/projects/pentaho/files/Data%20Integration/4.1.0-stable/pdi-ce-4.1.0-stable.tar.gz -O /tmp/pdi-ce-4.1.0-stable.tar.gz
    mkdir /opt/pentaho
    tar -zxf /tmp/pdi-ce-4.1.0-stable.tar.gz -C /opt/pentaho
    chmod +x /opt/pentaho/data-integration/*.sh
  EOH
end

