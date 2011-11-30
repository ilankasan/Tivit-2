class  MyDevise::SessionsController < Devise::SessionsController
   
 #before_filter :authenticate_account!
 
 # def new
  #	puts "In MyDevise Session Controller - New "
  #	puts " Params = "+params.inspect
  #	@title = "Sign In"
  #  super
    #redirect_to root_path
  #end

   def update
   	puts "++++ my devise sessions  update   ++++ + sessions ++++++++++++++++++++++++++++++++++++++++++"
	puts "in Account Controlls   00000000000000000000000000000000000000000000000000000"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
    super
  end
end 
 
 def create
 	puts "+++++ sessions create create    ++++++++++++++++++++++++++++++++++++++++++++++"
	puts "in Account Controlls   00000000000000000000000000000000000000000000000000000"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts params.inspect
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	super	
  
 end
 
  