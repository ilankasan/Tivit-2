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
    @url  = "http://localhost:3000"

    mail(:to => invitee.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "New tivit!")
  end
  
end
