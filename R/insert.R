# 
# OAuthString <- paste("Bearer", session['sessionID'])
# httpHeader <- httr::add_headers("Authorization"=OAuthString, "Accept"="application/xml", 'Content-Type'="application/xml")
# res <- httr::POST(url=URL, config=httpHeader, body=xmlBody)
# res.content = httr::content(res, as='text', encoding='UTF-8')
# 
# # Parse XML
# xdf <- xmlToDataFrame(getNodeSet(xmlParse(res.content),'//Result'))
# return(xdf)