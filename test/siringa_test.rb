require 'test_helper'
require 'minitest/spec'
require 'minitest/mock'

describe Siringa do

  describe "#dump_to" do

    it "run a command when the DB adapter is MySql" do
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Siringa.stub(:mysql_dump_command, "echo hola") do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is MySql" do
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Siringa.stub(:mysql_dump_command, "ls --wtf") do
          assert_equal({ :status => false,
                         :error => "ls: unrecognized option '--wtf'\nTry 'ls --help' for more information.\n",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

   it "run a command when the DB adapter is Sqlite" do
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Siringa.stub(:sqlite_dump_command, "echo hola") do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is Sqlite" do
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Siringa.stub(:sqlite_dump_command, "ls --wtf") do
          assert_equal({ :status => false,
                         :error => "ls: unrecognized option '--wtf'\nTry 'ls --help' for more information.\n",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

    it "raise an error using a not supported DB adapter" do
      Siringa.stub(:adapter_config, { :adapter => "whateverDB", :database => "test_database" }) do
        exception = assert_raises(NotImplementedError) { Siringa.dump_to("tmp/dumps") }
        assert_equal("Unknown adapter type 'whateverDB'", exception.to_s)
      end
    end

  end

  describe "#restore_from" do

    it "run a command when the DB adapter is MySql" do
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Siringa.stub(:mysql_restore_command, "echo hola") do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is MySql" do
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Siringa.stub(:mysql_restore_command, "ls --wtf") do
          assert_equal({ :status => false,
                         :error => "ls: unrecognized option '--wtf'\nTry 'ls --help' for more information.\n",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "run a command when the DB adapter is Sqlite" do
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Siringa.stub(:sqlite_restore_command, "echo hola") do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is Sqlite" do
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Siringa.stub(:sqlite_restore_command, "ls --wtf") do
          assert_equal({ :status => false,
                         :error => "ls: unrecognized option '--wtf'\nTry 'ls --help' for more information.\n",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "raise an error using a not supported DB adapter" do
      Siringa.stub(:adapter_config, { :adapter => "whateverDB", :database => "test_database" }) do
        exception = assert_raises(NotImplementedError) { Siringa.restore_from("tmp/dumps") }
        assert_equal("Unknown adapter type 'whateverDB'", exception.to_s)
      end
    end

  end

end
