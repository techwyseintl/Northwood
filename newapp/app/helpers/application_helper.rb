# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def nl2br(string)
    if !string.blank?
      string.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
    else
      ''
    end
  end

  # loading header image and styles
  def header_image
    header_img_path = request_from_reversemortgageplan? ? "reversemortgageplan/" : ''
    if @public_area and params[:path] and params[:path].empty?
      random_header = 1 + rand(7)
      content_tag(:div,'', :id => 'header_image', :style => "background-image: url(/images/headers/#{header_img_path}large/header#{random_header}.jpg)")
    else
      random_header = 1 + rand(8)
      content_tag(:div,'', :id => 'header_image', :style => "background-image: url(/images/headers/#{header_img_path}small/header#{random_header}.jpg); height: 226px; margin-bottom: 10px")
    end
  end
  
  
  # pagination link helpers (because default one is kinda broken)
  def pagination_prev_link
    prev_link = params.clone
    if params[:page].to_i - 1 > 0
      prev_link[:page] = prev_link[:page].to_i - 1
      prev_link
    else
      false
    end
  end
  
  def pagination_next_link(max)
    next_link = params.clone
    if params[:page].to_i < max
      next_link[:page] = 1 if next_link[:page].to_i == 0
      next_link[:page] = next_link[:page].to_i + 1
      next_link
    else
      false
    end
  end
  
  def value_or_space(value)
    (value.nil? or value.empty?) ? "&nbsp;" : value
  end
  
  def display_page(name)
    Page.find_by_name(name).html
  rescue
    ''
  end
  
  def display_header
    header = []
    if page_header = Header.find_by_path(request.env["PATH_INFO"])
      header << "<title>#{page_header.title}</title>" if page_header.title
      header << "\n<meta name='keywords' content=\"#{page_header.keywords}\" />"  if page_header.keywords
      header << "\n<meta name='description' content=\"#{page_header.description}\" />" if page_header.description
    else
      header << "<title>Northwood Mortgage#{(@page_title ? " - #{@page_title}" : "")}</title>"
    end
    header
  end
  
  def careers_conversion_code
    session[:show_careers_conversion] = nil
    return %{<!-- Google Code for Careers Conversion Page -->
    <script type="text/javascript">
    <!--
    var google_conversion_id = 1063174924;
    var google_conversion_language = "en";
    var google_conversion_format = "2";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "6hx9CNCSsgEQjIb7-gM";
    var google_conversion_value = 0;
    //-->
    </script>
    <script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js">
    </script>
    <noscript>
    <div style="display:inline;">
    <img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1063174924/?label=6hx9CNCSsgEQjIb7-gM&amp;guid=ON&amp;script=0"/>
    </div>
    </noscript>}
  end

end