module ApplicationHelper

  
  def logo
    image_tag("tivity.jpg", :alt => "tiviti Inc.", :class => "logo")
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "tivity"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # Check the client version used to access the application. No versioning distinction yet as it's really not needed at this point. 
  def client_browser_name
  
    user_agent = request.env['HTTP_USER_AGENT'].downcase
     
    if user_agent =~ /msie/i
      return "Internet Explorer"
    elsif user_agent =~ /konqueror/i
      return  "Konqueror"
    elsif user_agent =~ /gecko/i
      return  "Mozilla"
    elsif user_agent =~ /opera/i
      return "Opera"
    elsif user_agent =~ /applewebkit/i
      return "Safari"
    else
      return  "Unknown"
    end
  end
  
  def client_browser_supported?
    if (client_browser_name == "Internet Explorer" )
      return false
    else
      return true
    end
  end
                  
end