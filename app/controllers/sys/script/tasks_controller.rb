class Sys::Script::TasksController < ApplicationController
  def exec
    task = Sys::Task.new
    task.and :process_at, '<=', Time.now + (60 * 5) # before 5 min
    tasks = task.find(:all, :order => :process_at)
    
    if tasks.size == 0
      return render(:text => "No Tasks")
    end
    
    tasks.each do |task|
      begin
        unless unid = task.unid_data
          task.destroy
          raise 'Unid Not Found'
        end
        
        model = unid.model.underscore.pluralize
        item  = eval(unid.model).find_by_unid(unid.id)
        
        task_ctr = model.gsub(/^(.*?)\//, '\1/script/')
        task_act = "#{task.name}_by_task"
        task_prm = {:unid => unid, :task => task, :item => item}
        render_component_as_string :controller => task_ctr, :action => task_act, :params => task_prm
      rescue => e
        puts "Error: #{e}"
      end
    end
    
    render(:text => "OK")
  end
end
