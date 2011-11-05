# encoding: utf-8
module Joruri
  def self.version
    "1.1.6"
  end
  
  def self.default_config
    { "application" => {
      "sys.crypt_pass" => "joruri",
      "cms.publish_more_pages" => 0
    }}
  end
  
  def self.config
    $joruri_config ||= {}
    Joruri::Config
  end
  
  class Joruri::Config
    def self.application
      return $joruri_config[:imap_settings] if $joruri_config[:imap_settings]
      
      config = Joruri.default_config["application"]
      file   = "#{Rails.root}/config/application.yml"
      if ::File.exist?(file)
        yml = YAML.load_file(file)
        yml.each do |mod, values|
          values.each do |key, value|
            config["#{mod}.#{key}"] = value unless value.nil?
          end if values
        end if yml
      end
      $joruri_config[:application] = config
    end
  end
end