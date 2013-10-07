require 'test_helper'
require 'minitest/spec'
require 'minitest/mock'

describe Siringa do

  before do
    @process = MiniTest::Mock.new
  end

  describe "#dump_to" do

    it "run a command when the DB adapter is MySql" do
      @process.expect(:success?, true)
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "", @process]) do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is MySql" do
      @process.expect(:success?, false)
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "error message", @process]) do
          assert_equal({ :status => false,
                         :error => "error message",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

   it "run a command when the DB adapter is Sqlite" do
      @process.expect(:success?, true)
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "", @process]) do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps" }, Siringa.dump_to("tmp/dumps"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is Sqlite" do
      @process.expect(:success?, false)
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "error message", @process]) do
          assert_equal({ :status => false,
                         :error => "error message",
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
      @process.expect(:success?, true)
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "", @process]) do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is MySql" do
      @process.expect(:success?, false)
      Siringa.stub(:adapter_config, { :adapter => "mysql", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "error message", @process]) do
          assert_equal({ :status => false,
                         :error => "error message",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "run a command when the DB adapter is Sqlite" do
      @process.expect(:success?, true)
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "", @process]) do
          assert_equal({ :status => true,
                         :error => "",
                         :dump_path => "tmp/dumps/dump.dump" }, Siringa.restore_from("tmp/dumps/dump.dump"))
        end
      end
    end

    it "fail to run a bad command when the DB adapter is Sqlite" do
      @process.expect(:success?, false)
      Siringa.stub(:adapter_config, { :adapter => "sqlite3", :database => "test_database" }) do
        Open3.stub(:capture3, ["", "error message", @process]) do
          assert_equal({ :status => false,
                         :error => "error message",
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
