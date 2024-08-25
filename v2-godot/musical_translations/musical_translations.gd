extends Node

# Translates a list of 0-based integers into a single-spaced string.
# If a number is not less than the number of strings,
#  then wrap around with a modulo operation.
func integer_list_to_ordered_string_matches(integerList: Array, orderedStringList: Array) -> String:
	var mod = orderedStringList.count
	var converted_string_list = []
	
	for targetInteger in integerList:
		var ordered_string_index = targetInteger % mod
		converted_string_list += ' ' + orderedStringList[ordered_string_index]

	return converted_string_list.trim()
