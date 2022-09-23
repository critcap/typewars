extends VBoxContainer

var index: int

signal item_selected(index)

onready var ListItem = load("res://typewars/ListSelection/ListSelectionItem.tscn")


func _ready():
	visible = false


func open() -> void:
	visible = true
	if get_children().empty():
		return
	get_children()[0].select_item()


func setup_list(items: Array) -> void:
	for item in items:
		var list_item = ListItem.instance()
		add_child(list_item)

		var item_name = get_item_name_text(item)
		item_name = str("item ", items.find(item)) if item_name == "" else item_name
		list_item.setup(item_name)

		list_item.item.connect("pressed", self, "on_item_pressed", [items.find(item)])

	# setting the first and last elements to wrap
	var first := get_children()[0].item as Button
	var last := get_children()[-1].item as Button

	first.set_focus_neighbour(MARGIN_TOP, last.get_path())
	last.set_focus_neighbour(MARGIN_BOTTOM, first.get_path())


func on_item_pressed(item_index: int) -> void:
	if !visible:
		return
	emit_signal("item_selected", item_index)


func get_item_name_text(item) -> String:
	if item is String:
		return item
	if "name" in item:
		return item.name
	return ""
