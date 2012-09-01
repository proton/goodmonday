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

getXmlHttp = ->
  xmlhttp = undefined
  try
    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP")
  catch e
    try
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP")
    catch E
      xmlhttp = false
  xmlhttp = new XMLHttpRequest()  if not xmlhttp and typeof XMLHttpRequest isnt "undefined"
  xmlhttp

h = {}
eh = {}
elems = document.getElementsByClassName("goodmonday_adv")
if elems.length > 0
  for elem in elems
    size = '100x100'
    sizes = elem.className.match(/size_\d+x\d+/g)
    if sizes?
      if sizes.length>0
        size = sizes[0].substring(5)
    if h.hasOwnProperty(size)
      ++h[size]
      eh[size].push elem
    else
      h[size] = 1
      eh[size] = [elem]

  size_params = ''
  for k of h
    size_params += "sizes[#{k}]=#{encodeURIComponent(h[k])}&"

  url =  "http://r.goodmonday.ru/<%= @ground.id %>/advert.json?#{size_params}rn=#{Math.random()}"
  xmlhttp = getXmlHttp()
  xmlhttp.open "GET", url, true
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState is 4
      if xmlhttp.status is 200
        banners = eval("(#{xmlhttp.responseText})")
        for k of eh
          size_banners = banners[k]
          size_elems = eh[k]
          len = size_elems.length
          i = 0
          while i < len
            banner_code = size_banners[i]
            sub_id = size_elems[i].className.match(/subid_\S+/)  #TODO: not banner_code, INFA 100%
            if sub_id?
              if sub_id.length>0
                sub_id = sub_id[0].substring(6)
                banner_code = banner_code.replace('/goto',"/goto?sub_id=#{sub_id}")
            size_elems[i].innerHTML = banner_code
            i++

  xmlhttp.send null