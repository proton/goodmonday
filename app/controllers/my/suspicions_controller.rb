# coding: utf-8

class My::SuspicionsController < My::BaseOperatorController

	def index
		add_crumb "Подозрительные действия"
		@suspicions = Suspicion.pending
	end

	def block
		@suspicion = Suspicion.find(params[:suspicion_id])
		flash[:notice] = 'Заблокировано.' if @suspicion.block
		redirect_to :back
	end

	def forgive
		@suspicion = Suspicion.find(params[:suspicion_id])
		flash[:notice] = 'Скрыто.' if @suspicion.forgive
		redirect_to :back
	end
end
