class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_menu_articles

  protected

  def load_menu_articles
    @menu_articles = Article.where(:show_in_menu => true)
  end
end
