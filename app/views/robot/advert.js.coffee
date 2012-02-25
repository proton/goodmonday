if document.getElementsByClassName is `undefined`
  document.getElementsByClassName = (cl) ->
    retnode = []
    myclass = new RegExp("\\b" + cl + "\\b")
    elem = @getElementsByTagName("*")
    i = 0

    while i < elem.length
      classes = elem[i].className
      retnode.push elem[i]  if myclass.test(classes)
      i++
    retnode

elems = document.getElementsByClassName("goodmonday")
for key of elems
  elems[key].innerHTML = "<a href='http://188.255.106.235:3000/robot/<%= @ground.id %>/goto/<%= @offer.id %>/<%= @advert.id %>'>Текст!!!</a>"