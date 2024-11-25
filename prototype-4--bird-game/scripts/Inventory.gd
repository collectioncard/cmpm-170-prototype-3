extends Node

var CurrentToolIndex = 0;
var Inventory = [];


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory = [
		Item.new("Example Item 1", false),
		Item.new("Example Item 2", false),
		Item.new("Example Item 3", false),
		Item.new("Example Item 4", true),
		Item.new("Example Item 5", false),
	]


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			while true:
				CurrentToolIndex = (CurrentToolIndex + 1) % Inventory.size()
				if not Inventory[CurrentToolIndex].isDisabled:
					break
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			while true:
				CurrentToolIndex = (CurrentToolIndex - 1 + Inventory.size()) % Inventory.size()
				if not Inventory[CurrentToolIndex].isDisabled:
					break
		print(Inventory[CurrentToolIndex].itemName)
		
func getCurrentItem() -> Item:
	return Inventory[CurrentToolIndex];


	
class Item:
	var itemName: String;
	var isDisabled: bool;
	
	func _init(newItemName, isItemDisabled):
		self.itemName = newItemName;
		self.isDisabled = isItemDisabled;
		
	pass; 
