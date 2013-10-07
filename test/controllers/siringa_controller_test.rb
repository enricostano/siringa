require 'test_helper'

class SiringaControllerTest < ActionController::TestCase

  tests Siringa::SiringaController

  def setup
  end

  def teardown
    puts "LOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n #{File.read(Rails::logger.instance_variable_get("@logdev").instance_variable_get("@dev"))}\nLOG >>>>>>>>>>>>>>>>>>>>>>><<<<"
  end

  test "load action passing existing factory" do
    get :load, { definition: "initial", use_route: "siringa" }
    assert_response :success
  end

  test "load action passing a factory that doesn't exist" do
    get :load, { definition: "papapa", use_route: "siringa" }
    assert_response :method_not_allowed
  end

end
