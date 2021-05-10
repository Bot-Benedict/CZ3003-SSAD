extends Node

var result
var responseCode

func _ready():
	pass 

func loadUserInventory():
	
	var apiUrl = userInventoryModel.getBaseUrl() + '/' + userModel.getUserId()
	apiController.apiCallGet(apiUrl)
	yield(apiController, "request_completed")

	result = apiController.getResult()
	responseCode = apiController.getResponseCode()
	userInventoryModel.setUserInventory(result)
	
	for item in self.get_children():
		var idx = item.get_index()
		item.clear()
		item.append_bbcode(userInventoryModel.getQuantityByIdx(idx))

	get_parent().get_node("Loading").hide()