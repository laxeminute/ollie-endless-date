extends RichTextLabel


func _ready() -> void:
	meta_clicked.connect(_on_meta_clicked)


func _on_meta_clicked(meta: Variant) -> void:
	# NOTE: when we get around to translating,
	# make sure the link in the description points to the right language
	OS.shell_open(str(meta))
