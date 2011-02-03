module ApplicationHelper

  
  def logo
    image_tag("tivity.jpg", :alt => "Sample App", :class => "round")
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
  
  
end