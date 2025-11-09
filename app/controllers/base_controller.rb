class BaseController
  attr_reader :request
  def initialize(request)
    @request = request
  end

  private

  def build_response(body, status: 200)
    [status, {"Content-Type" => "text/html"}, [body]]
  end

  def redirect_to(uri)
    [302, {"Location" => uri},[]]
  end

  def params
    request.params
  end
end
