class_name BirdSet extends Node

var CurrentToolIndex = 0;
@export var Inventory = [];



func _input(event: InputEvent) -> void:
	var new_tool_index = -1;
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			new_tool_index = (CurrentToolIndex + 1) % Inventory.size();
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			new_tool_index = (CurrentToolIndex - 1 + Inventory.size()) % Inventory.size();
					
		if new_tool_index != -1:
			get_node(Inventory[CurrentToolIndex]).visible = false;
			get_node(Inventory[new_tool_index]).visible = true;
			CurrentToolIndex = new_tool_index;
			print_debug("Current Tool: " + str(Inventory[new_tool_index]));
		
		


	
class Item:
	var birdScene: CharacterBody2D;
	var isDisabled: bool;
	
	func _init(newItemName, isItemDisabled):
		self.birdScene = newItemName;
		self.isDisabled = isItemDisabled;
		
	pass; 
