require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name 
    self.to_s.downcase.pluralize 
  end
  # to create an abstract method that could be applied to any class and grab self (the class) name and change it into a string, downcase it and pluralize it because the table hold all the instance of the #class object  eg. class Dog ==> dogs
  
  def self.column_names 
    DB[:conn].results_as_hash = true
    sql = "PRAGMA table_info('#{table_name}')"
    table_info = DB[:conn].execute(sql)
    column_names = []
    
    table_info.each do |column| 
      column_names << column["name"]
    end
    column_names.compact
  end
  # the purpose of this method is draw out the hash of all of row and then iterate through it row and declare the name of that row and saving it into the empty array that is equal into the variable #'column_names', the results is still in an form of a key value pair and with the use of compact is to remove that relationship and to remove any residual nils and remaining elements are the attributes 
  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end
  
  def initialize (options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end

  def table_for_insert
    self.class.table_name
  end
  
  def values_for_insert
    values = []
    self.class.column_names.each do |col_name| 
      values << " '#{send(col_name)}' " unless send(col_name).nil? 
    end
    values.join(", ")
  end
  
  def col_names_for_insert
    self.class.column_names.delete_if{|col| col == id}.join(", ")
  end
  
  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{t})
    VALUES (#{values_for_insert})"
  DB[:conn].execute(sql)
  @id = DB[:conn].execute ("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
end

  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
    DB[:conn].execute(sql)
  end
  
end
