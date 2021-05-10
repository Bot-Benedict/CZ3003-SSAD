extends Node

#User Model
var baseUrl = "user"
var userID
var userEmail
var userName
var userPassword
var userRole
var userAvatarID
var userAvatar
var userGroup
var userCurrency

func getBaseUrl():
	return baseUrl
	
func setUserID(userID):
	self.userID = userID 

func setUserEmail(userEmail):
	self.userEmail = userEmail 
	
func setUserPassword(userPassword):
	self.userPassword = userPassword

func setUserAvatar(userAvatar):
	self.userAvatar = userAvatar

func setUserName(userName):
	self.userName = userName
	
func setUserAvatarID(userAvatarID):
	self.userAvatarID = userAvatarID

func setUserRole(userRole):
	self.userRole = userRole

func setUserGroup(userGroup):
	self.userGroup = userGroup

func setUserCurrency(userCurrency):
	self.userCurrency = userCurrency
		
func getUserRole():
	return userRole

func getUserId():
	return userID
	
func getUserPassword():
	return userPassword

func getUserEmail():
	return userEmail
	
func getUserAvatar():
	return userAvatar
	
func getUserName():
	return userName

func getUserAvatarID():
	return userAvatarID
	
func getUserGroup():
	return userGroup

func getUserCurrency():
	return userCurrency
