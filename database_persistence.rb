require "pg"

class DatabasePersistence
  def initialize
    @db = PG.connect(dbname: "flight_tracker")
  end

  def disconnect
    @db.close
  end

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def list
    sql = "SELECT * FROM flights ORDER BY id;"
    query(sql)
  end

  def add_flight(info)
    sql = <<~SQL
      INSERT INTO flights (airline, flight_number, destination,
        departure_time, departure_time_zone)
        VALUES ($1, $2, $3, $4, $5);
    SQL
    timestamp = "#{info[:date]} #{info[:time]}"
    query(sql, info[:airline], info[:flight_number].to_i, info[:destination], timestamp, info[:departure_time_zone])
  end

  def delete_flight(id)
    sql = "DELETE FROM flights WHERE id = $1"
    query(sql, id)
  end

  def flight_info(id)
    sql = "SELECT * FROM flights WHERE id = $1;"
    query(sql, id).first
  end

  def update_flight(info)
    sql = <<~SQL
      UPDATE flights SET airline=$1, flight_number=$2, destination=$3,
        departure_time=$4, departure_time_zone=$5 WHERE id=$6;
    SQL
    timestamp = "#{info[:date]} #{info[:time]}"
    query(sql, info[:airline], info[:flight_number].to_i, info[:destination], timestamp, info[:departure_time_zone], info[:id])
  end
end
