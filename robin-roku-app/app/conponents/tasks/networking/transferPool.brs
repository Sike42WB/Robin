function setUproUrlTransferPool(size = 5 as integer) as boolean
	if size <= 0 return false

	m.roUrlTransferPool = []
	if m.transferPoolSize <> invalid and m.transferPoolSize > 0 then size = m.transferPoolSize
	for i = 0 to size - 1
		roUrlTransfer = CreateObject("roUrlTransfer")

		idKey = roUrlTransfer.GetIdentity().ToStr().trim()
		transferItem = {
			"idKey" : idKey,
			"roUrlTransfer" : roUrlTransfer,
			"isAvailable" : true
		}
		m.roUrlTransferPool.push(transferItem)
	end for

	return true
end function

function FirstAvailableroUrlTransfer() as object
	if m.roUrlTransferPool = invalid then setUproUrlTransferPool()

	for each transferItem in m.roUrlTransferPool
		if transferItem.isAvailable = true
			transferItem.isAvailable = false
			return transferItem
		end if
	end for

	return invalid
end function

function findroUrlTransferByIdKey(idKey as String) as object
	if m.roUrlTransferPool = invalid then return invalid

	for each item in m.roUrlTransferPool
		if item.idKey = idKey
			return item
		end if
	end for

	return invalid
end function

function resetroUrlTransferByIdKey(idKey as String) as boolean
	if m.roUrlTransferPool = invalid then return invalid

	roUrlTransferItem = findroUrlTransferByIdKey(idKey)

	if roUrlTransferItem <> invalid and roUrlTransferItem.isAvailable = false
		roUrlTransfer = roUrlTransferItem.roUrlTransfer
		reset = roUrlTransfer.AsyncCancel()
		roUrlTransferItem.AddReplace("isAvailable", true)
		return true 'Means roUrlTransfer object is found and reset correctly
	else
		return false 'Means roUrlTransfer object not found so this function is called in a wrong postion, but doesn't affect the result
	end if
end function
