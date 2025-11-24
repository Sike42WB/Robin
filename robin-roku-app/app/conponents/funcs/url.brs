function HttpGET(constants, url, queryString = invalid, timeout = 20, cookies = invalid)
	if queryString <> invalid then
		if queryString.instr(0, "?") <> 0 then
			queryString = "?" + queryString
		end if
		url = url + queryString
	end if

	#if robin_enableLogs
		logDebug("[url.brs] Fetch raw ", url)
		loginfo("[url.brs] Fetch pretty: ")
		if url.instr("?") > 0 then
			urlParts = url.split("?")
			for each part in urlParts
				if part.instr(0, "&") > 0 then
					amps = part.split("&")
					for each amp in amps
						?"    &"; amp
					end for
				else
					?part
				end if
			end for
		else
			?url
		end if
	#end if

	port = createObject("roMessagePort")
	request = createObject("roURLTransfer")

	request.setUrl(url)
	request.setMessagePort(port)
	request.enableEncodings(true)
	request.retainBodyOnError(true)

	if url.instr(0, "https") = 0 then
		request.setCertificatesFile("common:/certs/ca-bundle.crt")
		request.initClientCertificates()
	end if

	if constants <> invalid then
		request.addHeader("User-Agent", constants.USER_AGENT)
		request.addHeader("Accept", "application/json")
	end if

	if cookies <> invalid then
		addCookiesToRequest(request, cookies)
	end if

	didSend = request.asyncGetToString()
	requestId = request.getIdentity().ToStr()

	response = invalid
	responseCode = -1
	responseHeaders = invalid

	if didSend then
		while true
			msg = wait(0, port)

			if msg = invalid then
				#if robin_enableLogs
				?"[url.brs] TIMEOUT! (cannot be bigger than 30 btw)"; requestId
				#end if
				request.asyncCancel()
				exit while
			end if

			if type(msg) = "roUrlEvent" and msg.getInt() = 1 and requestId = msg.getSourceIdentity().toStr() then
				responseCode = msg.getResponseCode()
				response = msg.getString()
				responseHeaders = msg.getResponseHeaders()
				exit while
			end if
		end while
	end if

	return {
		url: url,
		identity: requestId,
		statusCode: responseCode,
		headers: responseHeaders,
		body: response
	}
end function

function HttpGETJson(constants, url, queryString = invalid, timeout = 20, cookies = invalid)
	httpResponse = HttpGET(constants, url, queryString, timeout, cookies)

	if statusCodeOK(httpResponse.statusCode) then
		if httpResponse.body <> invalid and httpResponse.body <> "" then
			body = parseJSON(httpResponse.body)
			result = {
				url: httpResponse.url,
				identity: httpResponse.identity,
				statusCode: httpResponse.statusCode,
				headers: httpResponse.headers,
				body: body
			}
			httpResponse = invalid
			body = invalid
			return result
		end if
	end if

	httpResponse = invalid
	return invalid
end function

function GETJsonBody(constants, url, queryString = invalid, timeout = 20, cookies = invalid)
	httpResponse = HttpGET(constants, url, queryString, timeout, cookies)

	if statusCodeOK(httpResponse.statusCode) then
		if httpResponse.body <> invalid and httpResponse.body <> "" then
			result = parseJSON(httpResponse.body)
			httpResponse = invalid
			return result
		end if
	end if

	httpResponse = invalid
	return invalid
end function

function queryParam(key, value, at = "&") as String
	if key = invalid then return ""
	if value = invalid then return "key="
	return at + key + "=" + urlencode(value)
end function

function baseQueryParams(constants)
	url = queryParam("deviceType", constants.DEVICE_TYPE, "?")
	url = url + queryParam("deviceId", constants.DEVICE_ID)
	url = url + queryParam("deviceVersion", constants.DEVICE_VERSION)
	url = url + queryParam("deviceModel", constants.DEVICE_MODEL)
	url = url + queryParam("deviceSoftwareVersion", constants.DEVICE_FIRMWARE)
	url = url + queryParam("appId", "ROKU")
	url = url + queryParam("appVersion", constants.APP_VERSION)
    'TODO : Analytics
	'url = url + queryParam("buildVersion", constants.PHX_ANALYTICS_APP_VERSION)
	'url = url + queryParam("appName", constants.PHX_ANALYTICS_APP_NAME)
    ''''
	return url
end function

function urlencode(s)
	if s = invalid then return ""
	return s.escape()
end function

function getUserAgent(constants)
	di = createObject("roDeviceInfo")

	info =	{
		model: di.getModel(),
		version: di.getVersion()
	}

	info.version_major = mid(info.version, 3, 1)
	info.version_minor = mid(info.version, 5, 2)
	info.version_build = mid(info.version, 8, 5)

	if info.version_minor.toint() < 10 then
		info.version_minor = mid(info.version_minor, 2)
	end if

	versions = info.version_major + "." + info.version_minor + " (" + info.version + ") v" + getApplicationVersion()

	return "Roku/Robin-" + versions
end function

function getCookies(headers)
	cookies = {}
	if headers <> invalid then
		for each header in headers
			if header["set-cookie"] <> invalid then
				cookieParts = header["set-cookie"].split("; ")

				cookieName = invalid
				cookieValue = invalid

				if cookieParts.count() > 0 then
					equalSignIndex = cookieParts[0].instr("=")
					if equalSignIndex <> -1 then
						cookieName = left(cookieParts[0], equalSignIndex)
						cookieValue = mid(cookieParts[0], equalSignIndex + 2)
					end if
				end if

				if cookieName <> invalid and not cookies.doesExist(cookieName) then
					cookies.addReplace(cookieName, cookieValue)
					result = true
				end if
				exit for ' Got cookies!
			end if
		end for
	end if
	return cookies
end function

sub addCookiesToRequest(request, cookies)
	if request <> invalid and cookies <> invalid then
		url = request.getUrl()
		keys = cookies.keys()
		cookieVal = invalid

		for i = 0 to keys.count() - 1
			key = keys[i]
			if cookieVal = invalid then
				cookieVal = key + "=" + cookies[key]
			else
				cookieVal = cookieVal + "; " + key + "=" + cookies[key]
			end if
		next

		if cookieVal <> invalid then
			#if robin_enableLogs
			?"[url.brs] Adding cookie "; cookieVal
			#end if
			request.addHeader("Cookie", cookieVal)
		end if
	end if
end sub
