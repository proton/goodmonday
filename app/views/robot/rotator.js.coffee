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

gm_createRequestObject = ->
  if typeof XMLHttpRequest is "undefined"
    XMLHttpRequest = ->
      try
        return new ActiveXObject("Msxml2.XMLHTTP.6.0")
      try
        return new ActiveXObject("Msxml2.XMLHTTP.3.0")
      try
        return new ActiveXObject("Msxml2.XMLHTTP")
      try
        return new ActiveXObject("Microsoft.XMLHTTP")
      throw new Error("This browser does not support XMLHttpRequest.")

elems = document.getElementsByClassName("goodmonday_adv")
for elem in elems
  size = 'w100h100'
  sizes = elem.className.match(/size_w\d+h\d+/g)
  if sizes?
    if sizes.length>0
      size = sizes[0].substring(5)

  xmlhttp = getXmlHttp()
  xmlhttp.open "GET", "http://188.255.106.235:3000/robot/<%= @ground.id %>/advert/#{size}?rn=#{Math.random()}", true
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState is 4
      if xmlhttp.status is 200
#        alert xmlhttp.responseText
        elem.innerHTML = xmlhttp.responseText

  xmlhttp.send null
#  elem.innerHTML = "<a href='http://188.255.106.235:3000/robot/<%= @ground.id %>/goto/<%= @offer.id %>/<%= @advert.id %>'>Текст!!!</a>"