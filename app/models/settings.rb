class Settings < Settingslogic
  source "#{Conductor.root}/config/config.yml"
  namespace Conductor.env.to_s
  load!

  local_config = "#{Conductor.root}/config/config.local.yml"

  if File.exist?(local_config)
    instance.deep_merge!(Settings.new(local_config))
  end
end
