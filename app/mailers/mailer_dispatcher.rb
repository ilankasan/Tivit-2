class  MailerDispatcher 
      
      
  def self.dispatch(params)
      
    puts ">>>>>>>>>>>> new email dispatcher 6666664444444444"
    
   # puts params.inspect
    puts "___________________________________________________________"
  
    puts " Sending email "+params[:email_type]
    UserMailer.send(params[:email_type],params).deliver
   
    #UserMailer.send(params[:email_type],params[:assignee], params[:assigner],params[:tivit]).deliver
    puts "<<<<<<<<<<<< new email dispatcher 6666666644444444" 
    
  
  end


     
end
