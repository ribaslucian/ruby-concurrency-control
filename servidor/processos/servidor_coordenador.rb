class ServidorCoordenador

  def self.transaction_pay

    Mutex.new.synchronize {
      process_id = SecureRandom.hex[0..5]
      package = JSON.parse(@@request.env["rack.input"].read)

      log("* Iniciando Sub-Transação de Compra. Processo #{process_id}.")

      host_pay = ServidorHotel.compra_hospedagem(process_id, package)
      if host_pay != true
        DatabaseJson.tmp_delete process_id
        return {message: "Erro ao comprar hospedagem.", error: true}
      end

      flight_pay = ServidorVoo.compra_passagem(process_id, package)
      if flight_pay != true
        DatabaseJson.tmp_delete process_id
        return {message: "Erro ao comprar Voo.", error: true}
      end

      # compra && hospedagem correta, oficializa a compra
      DatabaseJson.tmp_effect process_id

      # protocol commit
      log("* Finalizando Sub-Transação de Compra.")

      return {error: false, params: process_id}
    }
  end

  def self.transaction type
    Mutex.new.synchronize {
      log("* Iniciando transação. Tipo '#{type}'.")

      if type == 'packages'
        data = ServidorCoordenador.packages

      elsif type == 'package_register'
        data = ServidorCoordenador.package_register

      elsif type == 'package_pay'
        # data = ServidorCoordenador.package_pay
        data = ServidorCoordenador.transaction_pay
      end

      log("* Fim de transação. Tipo '#{type}'. \n|")

      return data
    }
  end


  def self.packages
    Mutex.new.synchronize {
      # sleep 4
      database = DatabaseJson.read
      database.delete 'flights'
      database.delete 'hosts'
      return database
    }
  end


  def self.package_register
    Mutex.new.synchronize {
      params = JSON.parse(@@request.env["rack.input"].read)
      database = DatabaseJson.read
      client_id = params['client_id']
      package_id = SecureRandom.hex[0..3]

      database[client_id] = {} if !database.include? client_id
      database[client_id][package_id] = params
      DatabaseJson.save database

      return database[client_id]
    }
  end


  def self.package_cancel
    Mutex.new.synchronize {
      params = JSON.parse(@@request.env["rack.input"].read)
      database = DatabaseJson.read
      client_id = params['client_id']
      package_id = params['package_id']

      # existe o cliente E se existe o pacote
      if (database.include? client_id) && (database[client_id].include? package_id)
        database[client_id].delete package_id
        DatabaseJson.save database
      end

      return database[client_id]
    }
  end


  def self.package_pay
    Mutex.new.synchronize {
      params = JSON.parse(@@request.env["rack.input"].read)
      database = DatabaseJson.read
      client_id = params['client_id']
      package_id = params['package_id']

      # existe o cliente E se existe o pacote
      if (database.include? client_id) && (database[client_id].include? package_id)
        database[client_id][package_id]['status'] = 'Comprado'
        DatabaseJson.save database
      end

      return database[client_id]
    }
  end
end
