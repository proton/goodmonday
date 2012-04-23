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
end
