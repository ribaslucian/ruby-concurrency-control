# DatabaseJson.tmp_read 'd7t13urg'
# DatabaseJson.tmp_save 'd7t13urg', {supremos: 'deuses'}
# sleep 4
# DatabaseJson.tmp_effect 'd7t13urg'
class DatabaseJson


  def self.read
    log('Lendo. Banco de Dados Efetivo.');

    JSON.parse File.read('database.json')
  end


  def self.save data
    log('Salvando. Banco de dados Efetivo.');

    File.open('database.json', 'w') do |file|
      file.write data.to_json
    end
  end


  def self.tmp_read process_id
    db_file = "database_#{process_id}.tmp.json"

    if !File.exist? db_file
      log("Criando. Banco de dados temporário. Processo #{process_id}. Arquivo #{db_file}.");
      FileUtils.cp('database.json', db_file)
    end

    log("Lendo. Banco de dados temporário. Processo #{process_id}.");

    JSON.parse File.read(db_file)
  end


  def self.tmp_save process_id, data
    log("Salvando. Banco de dados temporário. Processo #{process_id}.");

    File.open("database_#{process_id}.tmp.json", 'w') do |file|
      file.write data.to_json
    end
  end


  def self.tmp_delete process_id
    log("Deletando. Banco de dados temporário. Processo #{process_id}. Arquivo database_#{process_id}.tmp.json.");
    File.delete "database_#{process_id}.tmp.json"
  end


  def self.tmp_effect process_id
    log("Efetivando. Banco de dados temporário. Processo #{process_id}.");
    DatabaseJson.save DatabaseJson.tmp_read(process_id)
    DatabaseJson.tmp_delete process_id
  end



end
