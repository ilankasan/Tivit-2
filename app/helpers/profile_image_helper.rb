module ProfileImageHelper
  
  def profile_image (user)
    
  #  puts "!!!!!!!!!!!!!!!!!!!!!!!   In profile image !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    if (user != nil && user.profile_image != nil && user.profile_image.avatar != nil && user.profile_image.avatar.url != nil)
  
      if(AvatarUploader.storage.kind_of?(File))
          return image_tag user.profile_image.avatar.url, :class => "avatar", :size => "40x40"
      else
#The line below needs to be generalized by taking amazon url and bucket name from a config file -->
          return image_tag user.profile_image.avatar.url.gsub("tiviti-heroku","tiviti-heroku.s3.amazonaws.com"), :class => "avatar", :size => "40x40" 
      end
  
    else
      return image_tag "/images/default-avatar.jpg", :class => "avatar" , :class => "avatar", :size => "40x40"

  end 

 end
end