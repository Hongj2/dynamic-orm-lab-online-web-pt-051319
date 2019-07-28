require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name 
    self.to_s.downcase.pluralize 
  end
  # to create an abstract method that could be applied to any class and grab self (the class) name and change it into a string, downcase it and pluralize it because the table hold all the instance of the class object  eg. class Dog ==> dogs
  
  def self.column_names 
    DB[:conn].results_as_hash = true
    sql = "pragma table_info('#{table.name}'"
    table_info = DB.excute(sql)
    column_names = []
    table_info.each do |row| 
      column_names << [row].name
    end
    column_names.compact
  end
  # the purpose of this method is 
end
