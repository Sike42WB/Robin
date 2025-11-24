sub init()
	m.constants = invalid
	m.input = invalid
	m.top.functionName = "runTask"
end sub

sub onConstantsChanged(msg)
	m.constants = msg
	m.input = m.top.input
'	execute()
end sub

function fetch()

'	url = BootstrapService_GetUrl()
'	return GETJsonBody(m.constants, url)
end function

sub failure()
	m.top.failed = true
end sub

sub done(response)

'	BootstrapService_ParseResult(response)
'	m.top.output = BootstrapService_Output()
	m.continueRunning = false
	
end sub
