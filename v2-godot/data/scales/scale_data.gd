class_name ScaleData extends Resource

## Full name of the scale. Not yet used.
@export var full_name = "full_display_name"

## Short name of the scale to display in a [Label].
@export var label_name = "Any Scale"

## List each solfege note of the scale in ascending order.
@export var solfege_ascending_notes: Array[SolfegeNoteData] = []

## List each solfege note of the scale in ascending order as a space-delimited
##  string. Not yet used.
@export var solfege_ascending_string = "Do di Re ri Mi Fa fi So si La li Ti"
