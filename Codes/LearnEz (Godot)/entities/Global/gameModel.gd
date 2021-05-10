extends Node

var baseUrl = "question/"
var currDifficulty = 5
var allQuestions = [[],[],[],[],[],[],[],[],[],[]]
var numQuestions = 1
var score = 0

func getBaseURL():
	return self.baseUrl

func setAllQuestionsByDifficulty(idx,question):
	allQuestions[idx].insert(allQuestions[idx].size(),question)

func setNumQuestions(numQuestions):
	self.numQuestions = numQuestions
	
func getQuestionsByDifficulty():
	return (allQuestions[currDifficulty-1])

func removeQuestionFromDifficulty(idx):
	getQuestionsByDifficulty().remove(idx)
	
func increaseDifficulty():
	if(currDifficulty != 10):
		currDifficulty += 1

func decreaseDifficulty():
	if(currDifficulty != 1):
		currDifficulty -= 1
	
func resetDifficulty():
	currDifficulty = 5
	
func decreaseQuestions():
	numQuestions -= 1

func resetNumQuestions():
	numQuestions = 5

func setScore(score):
	self.score = score

func getScore():
	return self.score
	
func calculateScore(mins,secs,ms):
	var score = int((currDifficulty*3)*(((mins*60)+secs+(ms/10))/2))
	setScore(score)
	print(score)
	pass