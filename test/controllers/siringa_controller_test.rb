require 'test_helper'

class SiringaControllerTest < ActionController::TestCase

  tests Siringa::SiringaController

  def setup
  end

  def teardown
  end

  test "load_definition action passing existing factory" do
    get :load_definition, { definition: "initial", use_route: "siringa" }
    assert_response :success
  end

  test "load_definition action passing a factory that doesn't exist" do
    get :load_definition, { definition: "papapa", use_route: "siringa" }
    assert_response :method_not_allowed
  end

  test "load_definition action passing arguments" do
    get :load_definition, {
      definition: "definition_with_arguments",
      siringa_args: { name: 'Robb Stark' },
      use_route: "siringa"
    }
    assert_response :success
  end

  test "load_definition action returning JSON response" do
    get :load_definition, {
      definition: "definition_with_return",
      siringa_args: { name: 'Ned' },
      use_route: "siringa"
    }
    assert body['id']
    assert_equal 'Ned', body['name']
    assert_equal 'Stark', body['surname']
  end
end
