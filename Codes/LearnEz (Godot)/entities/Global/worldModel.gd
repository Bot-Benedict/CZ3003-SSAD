extends Node

#World Model
var baseUrl = "world"
var selectedWorld
var selectWorldIdx
var worlds
var unlockStatus

func getBaseUrl():
	return baseUrl

func setWorlds(worlds):
	self.worlds = worlds

func setUnlockStatus(status):
	self.unlockStatus = status

func setSelectedWorld(worldID):
	self.selectedWorld = worldID

func setSelectedWorldIdx(idx):
	self.selectWorldIdx = idx
	
func getNumberOfWorlds():
	return worlds.size()
	
func getWorldByIdx(idx):
	return worlds[idx]

func getWorldNameByIdx(idx):
	return (worlds[idx])['worldName']

func getWorldUnlockStatus(idx):
	return (unlockStatus[idx])['unlock']

func getWorldScoreByIdx(idx):
	return (unlockStatus[idx])['score']
	
func getWorldIDbyIdx(idx):
	return (worlds[idx])['worldID']

