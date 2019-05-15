require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'
require './lib/database_json.rb'
require './lib/functions.rb'
require './lib/configs.rb'
require './processos/servidor_coordenador.rb'
require './processos/servidor_hotel.rb'
require './processos/servidor_voo.rb'



# lista os pacotes do cliente (client_id)
# @method GET client_id: string
get '/packages' do
  response_json({packages: ServidorCoordenador.transaction('packages')})
end

# adiciona um pacote para um cliente (client_id)
# @method POST {client_id: string, package: array}
post '/packages' do
  response_json({packages: ServidorCoordenador.transaction('package_register')})
end

# Confirma a compra de um pacote (package_id) de algum cliente (client_id)
# @method PUT {client_id: package_id: string}
put '/packages' do
  response_json(ServidorCoordenador.transaction('package_pay'))
end

# cancela um pacote (package_id) de algum cliente (client_id)
# @method DELETE {client_id: package_id: string}
delete '/packages' do
  response_json(ServidorCoordenador.package_cancel())
end



## rotas do servidor


# Lista os Voos
# @method GET
get '/flights' do
  database = DatabaseJson.read

  if database.include? 'flights'
    response_json({flights: database['flights']})
  else
    response_json({flights: {}})
  end
end

# Cadastra um Voo
# @method POST {city_destiny: string, price: float, date_departure: string, date_return: string}
post '/flights' do
  params = params_json
  database = DatabaseJson.read
  flight_id = SecureRandom.hex[0..3]

  database['flights'] = {} if !database.include? 'flights'
  database['flights'][flight_id] = params
  DatabaseJson.save database

  response_json database['flights']
end

# cancela um vooa (flight_id)
# @method DELETE {flight_id: string}
delete '/flights' do
  params = params_json
  database = DatabaseJson.read
  id = params['flight_id']

  # existe o cliente E se existe o pacote
  if (database.include? 'flights') && (database['flights'].include? id)
    database['flights'].delete id
    DatabaseJson.save database
  end

  response_json database['flights']
end




# Lista os Hoteis
# @method GET
get '/hosts' do
  database = DatabaseJson.read

  if database.include? 'hosts'
    response_json({hosts: database['hosts']})
  else
    response_json({hosts: {}})
  end
end

# Cadastra uma hospedagem de Hotel
# @method POST {city: string, price: float}
post '/hosts' do
  params = params_json
  database = DatabaseJson.read
  host_id = SecureRandom.hex[0..3]

  database['hosts'] = {} if !database.include? 'hosts'
  database['hosts'][host_id] = params
  DatabaseJson.save database

  response_json database['hosts']
end

# cancela um pacote (package_id) de algum cliente (client_id)
# @method DELETE {client_id: package_id: string}
delete '/hosts' do
  params = params_json
  database = DatabaseJson.read
  id = params['host_id']

  # existe o cliente E se existe o pacote
  if (database.include? 'hosts') && (database['hosts'].include? id)
    database['hosts'].delete id
    DatabaseJson.save database
  end

  response_json database['hosts']
end
