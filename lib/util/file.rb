class Util::File
  def self.put(path, options ={})
    if options[:mkdir] == true
      dir = ::File.dirname(path)
      FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
    end
    if options[:data]
      f = ::File.open(path, 'w')
      f.flock(File::LOCK_EX)
      f.write(options[:data] ? options[:data] : '')
      f.flock(File::LOCK_UN)
      f.close
    elsif options[:src]
      return false unless FileTest.exist?(options[:src])
      FileUtils.cp options[:src], path
    end
    return true
  end
end