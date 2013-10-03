require 'open3'

module Siringa

  # Generate dump file name
  #
  # @return [String]
  def self.dump_file_name
    "#{Siringa.configuration.dumps_path}/db_#{Time.now.strftime('%Y%m%d%H%M%S')}.dump"
  end

  # Create a DB dump
  #
  # @param [String] dump path
  # @return [Object]
  def self.dump_to(dump_path)
    result = {}
    case adapter_config[:adapter]
    when "mysql", "mysql2"
      _, result[:error], result[:status] = Open3.capture3(mysql_dump_command(adapter_config[:database], dump_path))
    when "sqlite3"
      _, result[:error], result[:status] = Open3.capture3(sqlite_dump_command(adapter_config[:database], dump_path))
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_config[:adapter]}'"
    end

    { :status => result[:status].success?, :error => result[:error], :dump_path => dump_path }
  end

  # Restore from a DB dump
  #
  # @param [String] dump path
  # @return [Object]
  def self.restore_from(dump_path)
    result = {}
    case adapter_config[:adapter]
    when "mysql", "mysql2"
      _, result[:error], result[:status] = Open3.capture3(mysql_restore_command(adapter_config[:database], dump_path))
    when "sqlite3"
      _, result[:error], result[:status] = Open3.capture3(sqlite_restore_command(adapter_config[:database], dump_path))
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_config[:adapter]}'"
    end

    { :status => result[:status].success?, :error => result[:error], :dump_path => dump_path }
  end

  # Delete oldest dump files, keep 5 dump files
  #
  # @param [Array] file names
  # @return [Boolean]
  def self.keep_five_dumps(dump_files)
    if dump_files.length > 5
      dump_files.first(dump_files.length - 5).each { |f| File.delete(f) }
      return true
    else
      return false
    end
  end

  # Retrieve a collection of dump files sorted by creation date
  #
  # @return [Array]
  def self.ordered_dumps
    Dir.glob("#{Siringa.configuration.dumps_path}/db_*.dump").sort_by { |f| File.mtime(f) }
  end

  private

  # Return a string with the dump command for MySql
  #
  # @param database [String]
  # @param dump_path [String]
  # @return [String]
  def self.mysql_dump_command(database, dump_path)
    "/usr/bin/env mysqldump -uroot #{database} > #{dump_path}"
  end

  # Return a string with the restore command for MySql
  #
  # @param database [String]
  # @param dump_path [String]
  # @return [String]
  def self.mysql_restore_command(database, dump_path)
    "/usr/bin/env mysql -uroot #{database} < #{dump_path}"
  end

  # Return a string with the dump command for Sqlite
  #
  # @param database [String]
  # @param dump_path [String]
  # @return [String]
  def self.sqlite_dump_command(database, dump_path)
    "/usr/bin/env sqlite3 #{database} '.backup #{dump_path}'"
  end

  # Return a string with the restore command for Sqlite
  #
  # @param database [String]
  # @param dump_path [String]
  # @return [String]
  def self.sqlite_restore_command(database, dump_path)
    "/usr/bin/env sqlite3 #{database} '.restore #{dump_path}'"
  end
  # Return ActiveRecord adapter config
  #
  # @return [Hash]
  def self.adapter_config
    ActiveRecord::Base.connection.instance_values["config"]
  end
end
