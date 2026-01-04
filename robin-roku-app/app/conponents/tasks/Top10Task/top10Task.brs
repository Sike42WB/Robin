sub init()
    m.top = m
end sub

sub runTop10()
    m.top.status = "running"

    url = m.top.url
    if url = invalid or url = "" then
        m.top.status = "error: no url"
        return
    end if

    ' Create transfer object
    xfer = CreateObject("roUrlTransfer")
    xfer.SetUrl(url)
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.InitClientCertificates()

    jsonString = xfer.GetToString()

    if jsonString = invalid or jsonString = "" then
        m.top.status = "error: empty response"
        return
    end if

    ' Parse JSON into AA
    json = ParseJson(jsonString)

    if json = invalid then
        m.top.status = "error: invalid json"
        return
    end if

    m.top.result = json
    m.top.status = "success"
end sub
