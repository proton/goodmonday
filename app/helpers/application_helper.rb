module ApplicationHelper
	def state_label(state)
		klass = case state
			when :accepted, :open
				'label-success'
			when :denied, :closed
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

  def number_to_rubles(x)
    number_to_currency(x/100.0)
  end

  def safe_image_tag(source, options = {})
    source ||= "rails.png"
    image_tag(source, options)
  end
end
