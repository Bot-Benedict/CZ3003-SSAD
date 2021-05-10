extends Node

var baseUrl = "powerup"
var powerups
var selectedPowerupIdx
var selectedPowerup

func setPowerups(powerups):
	self.powerups = powerups
	
func setSelectedPowerupIdx(idx):
	self.selectedPowerupIdx = idx

func setSelectedPowerup():
	self.selectedPowerup = self.powerups[self.selectedPowerupIdx]

func getSelectedPowerupIdx():
	return self.selectedPowerupIdx
		
func getSelectedPowerupName():
	return self.selectedPowerup['name']

func getSelectedPowerupCost():
	return self.selectedPowerup['cost']

func getSelectedPowerupID():
	return self.selectedPowerup['powerID']

func getSelectedPowerupDescription():
	return self.selectedPowerup['description']
	
func getBaseUrl():
	return baseUrl