extends Popup

func _ready():
	self.connect("about_to_show",self,"loadPowerupInformation")
	$buyBtn.connect("pressed",self,"checkUserCurrency")
	$CloseBtn.connect("pressed",self,"closePopup")

	pass # Replace with function body.
	
func loadPowerupInformation():
	
	$ErrorLbl.hide()
	
	var selectedPowerIdx = powerupModel.getSelectedPowerupIdx()
	
	$quantityLbl.clear()
	$quantityLbl.append_bbcode("[center]You have: " + userInventoryModel.getQuantityByIdx(selectedPowerIdx))
	$nameLbl.clear()
	$nameLbl.append_bbcode("[center]" + powerupModel.getSelectedPowerupName())
	$descriptionLbl.clear()
	$descriptionLbl.append_bbcode("[center]" + powerupModel.getSelectedPowerupDescription() + "[/center]")
	
	$buyBtn.get_node("cost").clear()
	$buyBtn.get_node("cost").append_bbcode("[center]" + powerupModel.getSelectedPowerupCost())
	
	for img in $SelectedPowerUpImg.get_children():
		if(img.get_index() == powerupModel.getSelectedPowerupIdx()):
			img.show()
		else:
			img.hide()
	pass

func checkUserCurrency():
	
	var userCurrency = userModel.getUserCurrency()
	var powerUpCost = int(powerupModel.getSelectedPowerupCost())
	var finalAmount
	
	if(userCurrency >= powerUpCost):
		self.hide()
		get_parent().get_node("Loading").show()
		finalAmount = userCurrency - powerUpCost
		userModel.setUserCurrency(finalAmount)
		
		#Do database update for User Currency
		var apiUrl = userModel.getBaseUrl() + '/currency/update/' + userModel.getUserId() 
		var data = {"currency": finalAmount}

		apiController.apiCallPut(data,apiUrl)
		
		yield(apiController, "request_completed")
		
		var userCurrencyLbl = get_parent().get_node("Currency/userCurrency")
		userCurrencyLbl.clear()
		userCurrencyLbl.append_bbcode("$" + str(userModel.getUserCurrency()))
		
		#Do database update for User Item quantity
		apiUrl = userInventoryModel.getBaseUrl() + "/" + userModel.getUserId()
		data = {"powerID": int(powerupModel.getSelectedPowerupID()), "add": "True"}
		
		apiController.apiCallPut(data,apiUrl)
		yield(apiController, "request_completed")
		
		get_parent().get_node("UserInventory").loadUserInventory()

	else:
		$ErrorLbl.show()
		
func closePopup():
	self.hide()