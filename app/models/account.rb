class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  #, :confirmable         :token_authenticatable,, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable ,:confirmable

# each account can be authnticated using FB, gmail and others services
  has_many :authentication_services, :dependent => :destroy
  
  # Setup accessible (or protected) attributes for your model, :,
  attr_accessible  :password, :password_confirmation, :remember_me, :email
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

                     
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  
  has_one :user, :foreign_key => "account_id"
  
  def get_name
  	return self.user.get_name
  end
  
end
