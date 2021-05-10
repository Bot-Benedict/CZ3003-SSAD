extends Node

#Performance
var studentsList
var selectedStudentIdx
var worlds
var selectedWorldIdx = 0

func setStudentsList(stuList):
	self.studentsList = stuList
	
func getStudentsList():
	return self.studentsList

func setSelectedStudentIdx(idx):
	self.selectedStudentIdx = idx
	
func getStudentNameByIdx(idx):
	return (studentsList[idx])['name']

func getStudentMatricByIdx(idx):
	return (studentsList[idx])['userID']
	
func getSelectedStudentIdx():
	return self.selectedStudentIdx
	
func setWorlds(worlds):
	self.worlds = worlds
	
func getWorlds():
	return self.worlds
	
func setSelectedWorldIdx(idx):
	self.selectedWorldIdx = idx

func getSelectedWorldIdx():
	return self.selectedWorldIdx

func getWorldNameByIdx(idx):
	return (worlds[idx])['worldName']
	
func getSelectedWorldIdByIdx(idx):
	return (worlds[idx])['worldID']
	
	