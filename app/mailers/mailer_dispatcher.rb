class  MailerDispatcher 
      
      
  def self.dispatch(params)
      
    puts ">>>>>>>>>>>> new email dispatcher " +params[:email_type]
    
    UserMailer.send(params[:email_type],params).deliver
   
    puts "<<<<<<<<<<<< new email dispatcher" 
    
  
  end


     
end
