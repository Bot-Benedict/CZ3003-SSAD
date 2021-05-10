extends Node

#Level Model
var baseUrl = "level"
var selectedLevel
var selectedLevelIdx
var levels
var unlockStatus

func getBaseUrl():
	return baseUrl

func setLevels(levels):
	self.levels = levels

func setUnlockStatus(status):
	self.unlockStatus = status

func setSelectedLevel(levelID):
	self.selectedLevel = levelID

func setSelectedLevelIdx(idx):
	self.selectedLevelIdx = idx

func getSelectedLevelIdx():
	return self.selectedLevelIdx
	
func getNumberOfLevels():
	return levels.size()
	
func getLevelByIdx(idx):
	return levels[idx]

func getLevelNameByIdx(idx):
	return (levels[idx])['levelName']

func getLevelStageByIdx(idx):
	return (levels[idx])['levelStage']

func getLevelUnlockStatusByIdx(idx):
	return (unlockStatus[idx])['unlock']

func getLevelScoreByIdx(idx):
	return (unlockStatus[idx])['score']

func getLevelIDByIdx(idx):
	return (unlockStatus[idx])['levelID']
		
func getLevelDescription(idx):
	return (levels[idx])['levelDescription']

