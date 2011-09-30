class Contact < ActiveRecord::Base
  belongs_to :user, :class_name => "User"
  belongs_to :mycontact, :class_name => "User", :foreign_key => "contact_id"
end
