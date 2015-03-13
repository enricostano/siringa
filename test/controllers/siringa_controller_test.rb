require 'test_helper'

class SiringaControllerTest < ActionController::TestCase

  tests Siringa::SiringaController

  def setup
  end

  def teardown
  end

  test "load action passing existing factory" do
    get :load, { definition: "initial", use_route: "siringa" }
    assert_response :success
  end

  test "load action passing a factory that doesn't exist" do
    get :load, { definition: "papapa", use_route: "siringa" }
    assert_response :method_not_allowed
  end

  test "load action passing arguments" do
    get :load, { definition: "definition_with_arguments", siringa_args: { name: 'Robb Stark' }, use_route: "siringa" }
    assert_response :success
  end

end
