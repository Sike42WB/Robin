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