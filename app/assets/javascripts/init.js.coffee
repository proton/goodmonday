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
  $('select').attr("data-placeholder","Выберите элементы из списка...").chosen(allow_single_deselect: true)