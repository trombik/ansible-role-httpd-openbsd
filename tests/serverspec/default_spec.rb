require "spec_helper"
require "serverspec"

package = "httpd-openbsd"
service = "httpd-openbsd"
config  = "/etc/httpd-openbsd/httpd-openbsd.conf"
user    = "httpd-openbsd"
group   = "httpd-openbsd"
ports   = [PORTS]
log_dir = "/var/log/httpd-openbsd"
db_dir  = "/var/lib/httpd-openbsd"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/httpd-openbsd.conf"
  db_dir = "/var/db/httpd-openbsd"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("httpd-openbsd") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/httpd-openbsd") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
