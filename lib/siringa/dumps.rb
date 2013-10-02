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
    adapter_config = ActiveRecord::Base.connection.instance_values["config"]
    case adapter_config[:adapter]
    when "mysql", "mysql2"
      _, result[:error], result[:status] = Open3.capture3("/usr/bin/env mysqldump -uroot #{adapter_config[:database]} > #{dump_path}")
    when "sqlite3"
      %x(/usr/bin/env sqlite3 #{adapter_config[:database]} '.backup #{dump_path}')
      result[:status] = $?.success?
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
    adapter_config = ActiveRecord::Base.connection.instance_values["config"]
    case adapter_config[:adapter]
    when "mysql", "mysql2"
      _, result[:error], result[:status] = Open3.capture3("/usr/bin/env mysql -uroot #{adapter_config[:database]} < #{dump_path}")
    when "sqlite3"
      %x(/usr/bin/env sqlite3 #{adapter_config[:database]} '.restore #{dump_path}')
      result[:status] = $?.success?
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

end
