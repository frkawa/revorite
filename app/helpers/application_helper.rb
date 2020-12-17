module ApplicationHelper
  def no_turbolink?
    if content_for(:no_turbolink)
      { data: {no_turbolink: true} }
    else
      { data: nil }
    end
  end
end
