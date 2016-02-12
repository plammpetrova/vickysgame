module Victoria
  class DataBase

    def has_record?(table, value, column)
      query = "SELECT #{column.upcase} FROM #{table.upcase} WHERE #{column.upcase}='#{value}';"

      SQLite3::Database.new("./victoria.db").execute(query) != []
    end

    def selector(select, from, where = nil, order_by = nil)
      select = "SELECT " + select
      from = " FROM " + from
      where = where ? " WHERE " + where : ""
      order_by = order_by ? " ORDER BY " + order_by : ""

      SQLite3::Database.new("./victoria.db").execute(select + from + where + order_by)
    end

    def inserter(table, values, columns)
      query = "INSERT INTO #{table} (#{columns}) VALUES (#{values})"

      SQLite3::Database.new("./victoria.db").execute(query)
    end

    def updater(update, set, where)
      SQLite3::Database.new("./victoria.db").execute("UPDATE #{update} SET #{set} WHERE #{where};")
    end
  end
end
