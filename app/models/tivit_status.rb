# 1 In_Progress
# 2 Completed
# 3 Closed
# 4 Deleted
# 5 On_it
# 6 Reviewed
# 


class TivitStatus < ActiveRecord::Base
  @in_progress = 1
  @completed   = 2
  
  def self.get_in_progress_id
    return @in_progress
  end
  
  def self.is_in_progress_id?(id)
    return (id==@in_progress)
  end
  
  def self.get_completed_id
    return @completed
  end
  
  def self.is_completed_id?(id)
    return  (id==@completed)
  end
  
end
