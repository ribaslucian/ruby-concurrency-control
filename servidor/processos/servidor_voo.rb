class ServidorVoo

  def self.compra_passagem(process_id, package)
    log("Compra de passagem iniciada. Processo #{process_id}.")
    database = DatabaseJson.tmp_read process_id
    package_full = database[package['client_id']][package['package_id']]
    
    #    flight.city_destiny = 'Cidade 1';
    #    flight.price = 10.99;
    #    flight.date_departure = '01/12/2019';
    #    flight.date_return = '02/12/2019';
    #    flight.status = 'disponivel';
    #
    #    package.client_id = 'lucian';
    #    package.city_destiny = 'gp';
    #    package.date_departure = '01/01/2020';
    #    package.date_return = '02/01/2020';
    #    package.people = 2;
    #    package.max_price = 74.23;
    #    package.status = 'Pendente';
    
    addressed = false
    database['flights'].each do |id, flight|
      if (package_full['city_destiny'] == flight['city_destiny']) && (package_full['date_departure'] == flight['date_departure']) && (package_full['date_return'] == flight['date_return']) && (flight['status'] == 'disponivel')
        database[package['client_id']][package['package_id']]['status'] = 'Comprado'
        database['flights'][id]['status'] = "comprado por #{package['client_id']}"
        addressed = true
      end
    end
    
    if addressed
      log("Voo encontrado. Comprado. Processo #{process_id}.")
      DatabaseJson.tmp_save process_id, database
    else
      log("Voo não encontrado. Cancelando... Processo #{process_id}.")
    end
    
    return addressed
  end

end
