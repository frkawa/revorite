module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Revorite"
    if page_title.empty?
      base_title
    else
      "#{ page_title } | #{ base_title }"
    end
  end  

  def no_turbolink?
    if content_for(:no_turbolink)
      { data: {no_turbolink: true} }
    else
      { data: nil }
    end
  end
end
