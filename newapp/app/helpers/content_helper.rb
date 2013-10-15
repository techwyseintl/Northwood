module ContentHelper  
  def header_links(*args)
    links = Array.new
    args.each do |item|
      if "/#{params[:path].to_s}" == item[1]
        links << link_to(item[0], item[1], {:class=>'active'})
      else
        links << link_to(item[0], item[1])
      end
    end
    content_tag :div, links.join(' | '), :class=>'header_links'
  end
end
