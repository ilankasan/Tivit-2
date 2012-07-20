# 1 In_Progress
# 2 Completed
# 3 New
# 4 Deleted
# 5 On_it
# 6 Reviewed
# 7 Reassigned 


class TivitStatus < ActiveRecord::Base
  @in_progress = 1
  @completed   = 2
  @new         = 3
  @declined    = 4
  @onit        = 5
  @reviewed    = 6
  @reassigned  = 7
  @proposed    = 8
  @reminded    = 9
  @accepted    = 10
  @closed      = 11 # closed are open tasks that their activity has been marked as completed
  @unassigned  = 12
  @not_started = 13 # tivit status. This is the initial status for tivits with owners that did not agree to help (before  on it)
   
  
  
# in progress id = 1
  def self.get_in_progress_id
    return @in_progress
  end
  
  def self.is_in_progress_id?(id)
    return (id==@in_progress)
  end

# completed id = 2
  def self.get_completed_id
    return @completed
  end
  
  def self.is_completed_id?(id)
    return  (id==@completed)
  end


# new id = 3
  def self.get_new_id
    return @new
  end
  
  def self.is_new_id?(id)
    return  (id==@new)
  end

# declined    = 4
  def self.get_declined_id
    return @declined
  end
  
  def self.is_declined_id?(id)
    return  (id==@declined)
  end



# on it id = 5
  def self.get_onit_id
    return @onit
  end
  
  def self.is_onit_id?(id)
    return  (id==@onit)
  end


# reviewed id = 6
  def self.get_reviewed_id
    return @reviewed
  end
  
  def self.is_reviewed_id?(id)
    return  (id==@reviewed)
  end


# re-assigned id = 7
  def self.get_reassigned_id
    return @reassigned
  end
  
  def self.is_reassigned_id?(id)
    return  (id==@reassigned)
  end
  
# proposed id = 8
  def self.get_proposed_id
    return @proposed
  end
  
  def self.is_proposed_id?(id)
    return  (id==@proposed)
  end
  

# proposed id = 9
  def self.get_reminded_id
    return @reminded
  end
  
  def self.is_reminded_id?(id)
    return  (id==@reminded)
  end
  
# accepted (proposed date) id = 10
  def self.get_accepted_id
    return @accepted
  end
  
  def self.is_accepted_id?(id)
    return  (id==@accepted)
  end
  
# closed id = 11
  def self.get_closed_id
    return @closed
  end
  
  def self.is_closed_id?(id)
    return (id==@closed)
  end

  
  
  # unassigned id = 12
  def self.get_unassigned_id
    return @unassigned
  end
  
  def self.is_unassigned_id?(id)
    return (id==@unassigned)
  end


# not started id = 13
  def self.not_started_id
    return @not_started
  end
  
  def self.is_not_started?(id)
    return (id==@not_started)
  end

end
