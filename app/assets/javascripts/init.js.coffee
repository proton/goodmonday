$ ->
  #bootstrap
  $(".alert-message").alert()
  $(".tabs").button()
  $(".carousel").carousel()
  $(".collapse").collapse()
  $(".dropdown-toggle").dropdown()
  $(".modal").modal()
  $("a[rel=popover]").popover()
#  $(".navbar").scrollspy() #fail with tabs
  $(".tab").tab "show"
  $(".tooltip").tooltip()
  $(".typeahead").typeahead()
  $("a[rel=tooltip]").tooltip()
  #chosen
  $("select").data("placeholder","Выбрете элементы из списка...").chosen()