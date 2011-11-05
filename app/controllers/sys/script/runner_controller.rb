# encoding: utf-8

class Sys::Script::RunnerController < ApplicationController
  def run
    Dir.chdir("#{Rails.root}")
    
    begin
      path = params[:paths].join('/')
      res  = render_component_as_string :controller => File.dirname(path),
        :action => File.basename(path)
    rescue => e
      puts "ScriptError: #{e}"
    end
    
    render :text => 'OK'
  end
end
