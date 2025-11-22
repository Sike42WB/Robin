sub cacheCryptoData(jsonString as String)
    reg = CreateObject("roRegistrySection", "CryptoCache")
    reg.Write("cryptoData", jsonString)
    reg.Flush() ' ensures data is saved
end sub
function getCachedCryptoData() as String
    reg = CreateObject("roRegistrySection", "CryptoCache")
    if reg.Exists("cryptoData")
        return reg.Read("cryptoData")
    else
        return "" ' empty string means no cache
    end if
end function


function regRead(key, section = invalid, default = invalid)
	if section = invalid then
		section = m.constants.APP_ENVIRONMENT
	end if

	sec = createObject("roRegistrySection", section)

	if sec.exists(key) then
		value = sec.read(key)
		return value
	end if

	return default
end function

sub regWrite(key, value, section = invalid)
	if section = invalid then
		section = m.constants.APP_ENVIRONMENT
	end if

	sec = createObject("roRegistrySection", section)
	sec.write(key, value)
	sec.flush()
end sub

sub regDelete(key, section = invalid)
	if section = invalid then
		section = m.constants.APP_ENVIRONMENT
	end if

	sec = createObject("roRegistrySection", section)
	sec.delete(key)
	sec.flush()
end sub

function secureRegRead(key, section = invalid, default = invalid, backupValue = "")
    temp = regRead(key, section , default )
    if temp = invalid then
        regWrite(key, backupValue, section)
        return backupValue
    end if
    return temp
end function