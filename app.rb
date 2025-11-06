require "json"

class App
  def call(env)
    req = Rack::Request.new(env)

    case [req.request_method, req.path_info]
    when ["GET", "/"]
      [
        200,
        { "Content-Type" => "application/json" },
        [ { message: "Hello from Fudo Challenge!" }.to_json ]
      ]
    else
      [
        404,
        { "Content-Type" => "application/json" },
        [ { error: "Not Found" }.to_json ]
      ]
    end
  end
end
