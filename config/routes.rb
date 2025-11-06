class Router
  def call(env)
    req = Rack::Request.new(env)
    case [req.request_method, req.path_info]
    when["POST", "/auth"]
      print "post, auth"
    when["POST", "/products"]
      print "post, products"
    when["GET", "/products"]
      print "get, products"
    end
  end
end

