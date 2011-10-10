class  MyDevise::AccountsController < Devise::AccountsController
   
 before_filter :authenticate_account!
 
  def new
  	puts "+++++++++++++ acount +++++++++++++++++++++++++++++++++++++"
	puts "NEEWWWWWWWWWWWWWWWWWWWW    00000000000000000000000000000000000000000000000000000"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
    super
  end

   def update
   	puts "++++ account update   ++++++++++++++++++++++++++++++++++++++++++++++"
	puts "in Account Controlls   00000000000000000000000000000000000000000000000000000"
	
	puts params.inspect
	
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
    super
    
    
  
end 
 
 def create
 	puts "++++accounts  ++++++++++++++++++++++++++++++++++++++++++++++"
	puts "in Account Controlls   00000000000000000000000000000000000000000000000000000"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts params.inspect
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	super	
  
 end
 
 end