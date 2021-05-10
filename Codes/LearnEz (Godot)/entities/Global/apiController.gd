extends HTTPRequest

var baseUrl = 'https://learnez.a2hosted.com/public/api/'

var result 
var response_code 

func _ready():
	connect("request_completed",self,"_on_HTTPRequest_request_completed")
	pass # Replace with function body.
	
func apiCallGet(url):
	var requestUrl = baseUrl + url 
	request(requestUrl)

func apiCallPut(data,url):
	var query = JSON.print(data)
	var requestUrl = baseUrl + url 
	var headers = ["Content-Type: application/json"]
	request(requestUrl, headers,false, HTTPClient.METHOD_PUT, query)
	
func apiCallPost(data,url):
	var query = JSON.print(data)
	var requestUrl = baseUrl + url 
	var headers = ["Content-Type: application/json"]
	request(requestUrl, headers,false, HTTPClient.METHOD_POST,query)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_ascii())
	self.result = json.result
	self.response_code = response_code
	emit_signal("request_completed")

func getResult():
	return self.result

func getResponseCode():
	return self.response_code
