# Functions to convert between integers, strings, and solfege strings.
# Translated from original Python code into GDScript on 8/25/2024.


"""
Translates each list of integers, within a list, into a
	string of solfege names.
N: Currently only for Major scale.
iltsolfege means Integers_List_To_Solfege

>>> iltsolfege([[0, 1, 2]], "Do Re Mi Fa So La Ti".split())
['Do Re Mi']
>>> iltsolfege([[0, 1, 2], [0,3,4]], "Do Re Mi Fa So La Ti".split())
['Do Re Mi', 'Do Fa So']
"""
func iltsolfege(intsList, scaleNames):
	var mod = len(scaleNames)
	var result = []
	for nums in intsList:
		var temp = []
		for num in nums:
			var noteIndex = num % mod
			temp += [scaleNames[noteIndex]]
		temp = ' '.join(temp)
		result.append(temp)
	return result


"""
iListsToSolfege means Integers_Lists_To_Solfege

>>> iListsToSolfege([[0, 1, 2]], "Do Re Mi Fa So La Ti".split())
"Do Re Mi"
>>> iListsToSolfege([[0], [0], [0]], "Do Re Mi Fa So La Ti".split())
"Do (rest) Do (rest) Do"
"""
func iListsToSolfege(intsLists, scaleNames):
	var strList = iltsolfege(intsLists, scaleNames)
	return ' (rest) '.join(strList)


"""
Translate each list of integers, within a list, into a
	string of solfege names.
Insert `(rest)` between each word.

>>> iListsToSolfege([[0, 1, 2]], "Do Re Mi Fa So La Ti".split())
"Do Re Mi"
>>> iListsToSolfege([[0], [0], [0]], "Do Re Mi Fa So La Ti".split())
"Do (rest) Do (rest) Do"
"""
func integer_lists_to_solfege_string(intsList, scaleNames):
	var modulo_as_total_count_of_scale_degrees = len(scaleNames)
	var result_solfege_list_where_each_item_was_a_word = []
	for nums in intsList:
		var temp = []
		for num in nums:
			var noteIndex = num % modulo_as_total_count_of_scale_degrees
			temp += [scaleNames[noteIndex]]
		temp = ' '.join(temp)
		result_solfege_list_where_each_item_was_a_word.append(temp)
	
	return ' (rest) '.join(result_solfege_list_where_each_item_was_a_word)


"""
'scale' means the number of unique tones
	in the scale used.
"""
func myStrToInt(s, scale=12):
	var result = []
	# For each character in s
	for character in s:
		var num = character.to_utf8_buffer()[0] - 65
		if num <= -1 or num >= 26:
			# Invalid character detected. Skip it.
			continue
		result.append(num % scale)
	return result


"""
Input:  String.
Output: Caps locked list of strings, where each word is
		an element.
	Removes whitespace characters.
"""
func prepareStr(s):
	return s.strip_edges().to_upper().split(' ')
