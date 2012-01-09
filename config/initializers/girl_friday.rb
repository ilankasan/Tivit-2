EMAIL_QUEUE = GirlFriday::WorkQueue.new(:mailer_dispatcher, :size => 3) do |params|
  #UserMailer.registration_email(msg).deliver
  MailerDispatcher.dispatch(params)
   
end