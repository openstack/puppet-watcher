Puppet::Type.type(:watcher_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/watcher/watcher.conf'
  end

end
