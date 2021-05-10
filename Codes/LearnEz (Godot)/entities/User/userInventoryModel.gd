extends Node

#User Inventory Model
var baseUrl = "userpowerup"

var userInv

func setUserInventory(userInv):
	self.userInv = userInv
	
func getBaseUrl():
	return baseUrl
	
func getQuantityByIdx(idx):
	return userInv[idx]['quantity']

func getPowerIdByIdx(idx):
	return userInv[idx]['powerID']
	
func reducePowerupQuantyByIdx(idx):
	userInv[idx]['quantity'] = str(int(userInv[idx]['quantity']) - 1)