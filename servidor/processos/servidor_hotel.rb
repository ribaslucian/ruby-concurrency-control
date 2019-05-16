class ServidorHotel

  def self.compra_hospedagem(process_id, package)
    log("Compra de hospedagem iniciada. Processo #{process_id}.")
    database = DatabaseJson.tmp_read process_id
    package_full = database[package['client_id']][package['package_id']]
    
    #    host.name = 'Hotel 1';
    #    host.city = 'Cidade 1';
    #    host.price = 10.99;
    #    host.status = 'disponivel';
    #
    #    package.client_id = 'lucian';
    #    package.city_destiny = 'gp';
    #    package.date_departure = '01/01/2020';
    #    package.date_return = '02/01/2020';
    #    package.people = 2;
    #    package.max_price = 74.23;
    #    package.status = 'Pendente';

    if package_full['status'] != 'Pendente'
      log("Pacote já Comprado. Cancelando... Processo #{process_id}.")
      return false
    end
    
    addressed = false
    database['hosts'].each do |id, host|
      # if (package_full['city_destiny'] == host['city']) && (package_full['date_departure'] == host['date_departure']) && (package_full['date_return'] == host['date_return'])
      if (package_full['city_destiny'] == host['city']) && (host['status'] == 'disponivel')
        database[package['client_id']][package['package_id']]['status'] = 'Comprado'
        database['hosts'][id]['status'] = "comprado por #{package['client_id']}"
        addressed = true
      end
    end
    
    if addressed
      log("Hospedagem Encontrada. Comprada. Processo #{process_id}.")
      DatabaseJson.tmp_save process_id, database
    else
      log("Hospedagem Não Encontrada. Cancelando... Processo #{process_id}.")
    end
    
    return addressed
  end

end
