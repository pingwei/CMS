class Cms::Map < ActiveRecord::Base
  include Sys::Model::Base
  
  def is_point(num)
    return false if self.send('point' + num.to_s + '_name').to_s ==''
    return false if self.send('point' + num.to_s + '_lat').to_s ==''
    return false if self.send('point' + num.to_s + '_lng').to_s ==''
    return true;
  end
  
  def get_point_params(num)
    return self.send('point' + num.to_s + '_lat') +
      ', ' + self.send('point' + num.to_s + '_lng') +
      ", '" + self.send('point' + num.to_s + '_name').gsub(/'/, "\\\\'").gsub(/\r\n|\r|\n/, "<br />") + "'"
  end
end
