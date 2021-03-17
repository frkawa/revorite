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

  def lazy_image_tag(source, options={})
    options['data-original'] = asset_path(source)
    if options[:class].blank?
      options[:class] = 'lazy'
    else
      options[:class] = "lazy #{options[:class]}"
    end

    image_tag('preload.gif', options)
  end
end
