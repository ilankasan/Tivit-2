class  MailerDispatcher 
      
      
  def self.dispatch(params)
      
    puts ">>>>>>>>>>>> dispatching -> " +params[:email_type]
    
    UserMailer.send(params[:email_type],params).deliver
   
    puts "<<<<<<<<<<<< dispatcher" 
    
  
  end


     
end
