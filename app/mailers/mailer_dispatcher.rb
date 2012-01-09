class  MailerDispatcher 
      
      
  def self.dispatch(params)
      
    puts ">>>>>>>>>>>> new email dispatcher "
    
   # puts params.inspect
#    puts "___________________________________________________________"
  
 #   puts " Sending email "+params[:email_type]
    UserMailer.send(params[:email_type],params).deliver
   
    #UserMailer.send(params[:email_type],params[:assignee], params[:assigner],params[:tivit]).deliver
    puts "<<<<<<<<<<<< new email dispatcher" 
    
  
  end


     
end
