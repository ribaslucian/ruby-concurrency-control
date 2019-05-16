# function utils

def response_json data
  @response.status = 200
  @response['Content-Type'] = 'application/json; charset=utf-8'
  @response['Access-Control-Allow-Origin'] = 'http://localhost'
  @response.body = data.to_json
end

def params_json
  JSON.parse @request.env["rack.input"].read
end

def log message
  File.write('transactions.log', Time.now().strftime('%d/%m/%Y %H:%M:%S') + ': ' + message + "\n", mode: 'a')
end
