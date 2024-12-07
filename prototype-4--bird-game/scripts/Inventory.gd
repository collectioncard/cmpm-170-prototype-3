class_name BirdSet extends Node

var CurrentToolIndex = 0;
@export var Inventory = [];

@onready var label: Label = %birdLabel

func _input(event: InputEvent) -> void:
	var new_tool_index = -1;
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 2080);
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			new_tool_index = (CurrentToolIndex + 1) % Inventory.size();
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			new_tool_index = (CurrentToolIndex - 1 + Inventory.size()) % Inventory.size();
					
		if new_tool_index != -1:
			get_node(Inventory[CurrentToolIndex]).visible = false;
			get_node(Inventory[CurrentToolIndex]).process_mode = Node.PROCESS_MODE_DISABLED;
			get_node(Inventory[new_tool_index]).visible = true;
			get_node(Inventory[new_tool_index]).process_mode = Node.PROCESS_MODE_INHERIT;
			get_node(Inventory[new_tool_index]).position = Vector2.ZERO;
			label.text = "Current Bird: " + get_node(Inventory[new_tool_index]).name;
			CurrentToolIndex = new_tool_index;
			print_debug("Current Tool: " + str(Inventory[new_tool_index]));
		
		


	
class Item:
	var birdScene: CharacterBody2D;
	var isDisabled: bool;
	
	func _init(newItemName, isItemDisabled):
		self.birdScene = newItemName;
		self.isDisabled = isItemDisabled;
		
	pass; 
