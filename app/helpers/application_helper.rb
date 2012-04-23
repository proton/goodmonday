module ApplicationHelper
	def label(state)
		klass = case state
			when :accepted
				'label-success'
			when :denied, :closed
				'label-important'
		end
		"<span class='label #{klass}'>#{t(("common.state."+state.to_s).to_sym)}</span>".html_safe
	end
end
