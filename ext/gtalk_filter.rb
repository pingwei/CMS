#!/usr/local/bin/ruby
# encoding: utf-8
# $KCODE = 'UTF-8'
require 'nkf'
require 'logger'
require 'shell'

class GtalkFilter
  def initialize
    dir = File.dirname(__FILE__)
    @chasen   = '/usr/bin/chasen'
    @chasenrc = File.expand_path('./config/chasenrc_gtalk', dir)
    @chaone   = File.expand_path('./morph/chaone/chaone', dir)
    @log_file = File.expand_path('./filter.log', dir)
  end
  
  def execute(text)
    x = ''
    p = ''
    c = exec_chaone('、')
    
    text = NKF.nkf('-w', text)
    text.split(/。/).each do |s|
      s.split(/、/).each do |w|
        w = '、' + w
        if (p.split(//u).size + w.split(//u).size) > 60
          x += exec_chaone(p)
          p = w
        else
          p += w
        end
      end
      if p != ''
        x += exec_chaone(p)
        p = ''
      end
      x += c
    end
    
    x = "<S>#{x}</S>"
    return NKF.nkf('-e', x)
  end
  
  def exec_chaone(str)
    cmd = "echo \"#{str}\" | #{@chasen} -i w -r #{@chasenrc} | #{@chaone} -e UTF-8 -s gtalk"
    res = `#{cmd}`.to_s
    res = NKF.nkf('-Ww', res)
    return '' if $? != 0 || res.slice(0, 1) != '<'
    res.sub!('<S>', '')
    res.sub!('</S>', '')
    return res
  rescue Exception => e
    ''
  end
  
  def log(msg)
    Logger.new(@log_file).debug(msg)
  end
end

begin
  puts GtalkFilter.new.execute($stdin.gets.to_s)
end
