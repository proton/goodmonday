module ApplicationHelper
	def state_label(state)
		klass = case state
			when :accepted, :open, :success
				'label-success'
			when :denied, :closed, :error
				'label-important'
		end
		"<span class='label #{klass}'>#{t(("common.state."+state.to_s).to_sym)}</span>".html_safe
	end

	def add_sidebar_link(text, url, icon = nil)
		active = (url==request.path)
		icon_raw = ''
		icon_raw = "<i class='icon-#{icon.to_s}#{active ? ' icon-white' : ''}'></i> " if icon
		"<li#{active ? " class='active'": ''}><a href='#{url}'>#{icon_raw}#{text}</a></li>".html_safe
  end

  def safe_image_tag(source, options = {})
    source ||= "rails.png"
    image_tag(source, options)
  end

  def print_datetime(dt)
    content_tag(:span, dt.to_s, :class => 'datetime', :data => {:timestamp => dt.utc.strftime('%Y/%m/%d/%H/%M')})
  end
end
