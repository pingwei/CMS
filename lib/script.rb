class Script
  cattr_reader :options
  
  def self.run(path, options = nil)
    @@options = options
    
    lock_key = 'script_' + path.gsub(/\W/, "_")
    if lock(lock_key) == false
      puts "[ #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} ]: Script.run('#{path}') already running."
      return true
    end
    
    begin
      puts "[ #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} ]: Script.run('#{path}') started."
      app = ActionController::Integration::Session.new
      app.get "/_script/sys/run/#{path}"
      puts "[ #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} ]: Script.run('#{path}') finished."
    rescue => e
      puts "ScriptError: #{e}"
    end
    unlock(lock_key)
  end
  
protected
  def self.lock(lock_key)
    file = "#{Rails.root}/tmp/#{lock_key}"
    if ::File.exist?(file)
      locked = ::File.stat(file).mtime.to_i
      return false if Time.now.to_i < locked + (60*60*2)
      unlock(lock_key)
    end
    ::File.open(file, 'w')
    return true
  rescue
    return false
  end
  
  def self.unlock(lock_key)
    file = "#{Rails.root}/tmp/#{lock_key}"
    ::File.unlink(file)
  end
end