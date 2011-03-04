class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@gmail.com"
  def welcome_email(user)
    @user = user
    @url  = "http://http://tivit1.heroku.com/"
    mail(:to => user.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "Welcome to tiviti!")
  end
  
  
  def new_tivit_email(invitee, owner,tivit)
    @invitee = invitee
    @owner   = owner
    @tivit   = tivit
    
    #@url  = "http://http://tivit1.heroku.com/"
 #   if(config == nil)
  
  #  if(config.port != nil)
   # 	@url  = "http://"+config.host_name+":"+config.port
    #else
    #	@url  = "http://"+config.host_url["localhost"]
    				      
    #end
@url  = "http://tivit1.heroku.com"
    mail(:to => invitee.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "New tivit!")
  end
  
end
