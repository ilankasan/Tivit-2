EMAIL_QUEUE = GirlFriday::WorkQueue.new(:user_email, :size => 3) do |params|
  #UserMailer.registration_email(msg).deliver
  UserMailer.dispatcher(params)
   
end