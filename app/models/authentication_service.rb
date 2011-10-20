class AuthenticationService < ActiveRecord::Base
	 belongs_to :account
  	 attr_accessible :provider, :uid, :uname, :uemail
end
