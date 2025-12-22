' Sampel input:
' {
'		name: "any name"
'		url: "https://..."
'		important: (true|false) ' of true skips the request queue
'		fireAndForget: (true|false) ' Do only parse the response if it is not a "fire and forget".
' }

sub init()
	m.maxConcurrentItems = 5 ' holds the number of request that can be added in the request que (m.incomingRequestsPool)
	m.top.functionName = "NetworkingTask_Run"
end sub

sub NetworkingTask_Run()
	setUproUrlTransferPool(m.maxConcurrentItems)
	m.incomingRequestsPool = []
	m.processingRequestsPool = []

	m.port = CreateObject("roMessagePort")
	m.top.observeField("input", m.port)


	while true
		msg = wait(0, m.port)
		if msg <> invalid then

			' Add input request to queue
			' "important" ones skip the line
			if type(msg) = "roSGNodeEvent" then
				field = msg.getField()
				data = msg.getData()

				if field = "input" then
					handleInputNodeEvent(data)
				else if field = "constants" then
					onConstantsChanged(data)
				end if
			end if

			' Process any event that ccomes from the port,
			' output it if it is not a fire-and-forget.
			if type(msg) = "roUrlEvent" and msg.getInt() = 1 then
				responseCode = msg.getResponseCode()
				response = msg.getString()
				responseHeaders = msg.getResponseHeaders()
				requestId = msg.getSourceIdentity().toStr()

				resetroUrlTransferByIdKey(requestId)

				newProcessingPool = []
				input = invalid
				for each event in m.processingRequestsPool
					if event.id <> requestId then
						newProcessingPool.push(event)
					else
						input = event
					end if
				end for
				m.processingRequestsPool = newProcessingPool

				if not input.fireAndForget then
					jsonResponse = ParseJSON(response)
					cookies = getCookies(msg.getResponseHeadersArray())
					if jsonResponse <> invalid then
						m.top.output =  {
							name: input.name,
							statusCode: responseCode,
							headers: responseHeaders,
							cookies: cookies,
							body: jsonResponse,
							failureReason: msg.getFailureReason()
						}
					else
						m.top.output =  {
							name: input.name,
							statusCode: 401,
							headers: responseHeaders,
							cookies: cookies,
							body: invalid,
							failureReason: "JSON is invalid."
						}
					end if
				end if
				executeNextInLine()
			end if
		end if

		executeNextInLine()
	end while
end sub

sub handleInputNodeEvent(data as Object)
	if data.important = true then
		firstData = [data]
		firstData.append(m.incomingRequestsPool)
		m.incomingRequestsPool = firstData
	else
		m.incomingRequestsPool.push(data)
	end if
end sub

sub onConstantsChanged(data)
	m.constants = data
end sub

sub executeNextInLine()
	if m.incomingRequestsPool.count() > 0 and m.processingRequestsPool.count() < m.maxConcurrentItems then
		input = m.incomingRequestsPool.shift()
		url = input.url
		cookies = input.cookies

		transferItem = FirstAvailableroUrlTransfer()
		request = transferItem.roUrlTransfer
		request.setUrl(url)
		request.setMessagePort(m.port)
		request.enableEncodings(true)
		request.retainBodyOnError(true)

		if url.instr(0, "https") = 0 then
			request.setCertificatesFile("common:/certs/ca-bundle.crt")
			request.initClientCertificates()
		end if

		if cookies <> invalid and cookies.keys().count() > 0 then
			addCookiesToRequest(request, cookies)
		end if

		if m.constants <> invalid then
			request.addHeader("User-Agent", m.constants.USER_AGENT)
			request.addHeader("Accept", "application/json")
		end if

		didSend = request.asyncGetToString()
		requestId = request.getIdentity().ToStr()
		transferItem.idKey = requestId

		m.processingRequestsPool.push({
			id: requestId,
			name: input.name,
			fireAndForget: input.fireAndForget
		})
	end if
end sub
