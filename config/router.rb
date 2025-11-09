class Router
  def initialize(request)
    @request = request
  end

  def route!
    if @request.path == "/"
      [200, { "Content-Type" => "text/plain"}, ["Hello"]]
    else
      not_found
    end
  end

  private

  def not_found(msg = "Not Found")
    [404, {"Content-Type" => "text/plain"}, [msg]]
  end

  #route info returns a hash with the "routing coordinates"
  #First element = resource
  #Second element = action to do (can be show, new, index or create depending of the http method
  #and the id
  #Third id if it exists
  def route_info
    @route_info ||= begin
                      resource = path_fragments[0] || "base"
                      id, action = find_id_and_action(path_fragments[1])
                      { resource: resource, action: action, id: id}
                    end
  end


  def find_id_and_action(fragment)
    case fragment
    when "new"
      [nil, :new]

    when nil
      action = @request.get? ? :index : :create
      [nil, action]
    else
      [fragment, :show]
    end
  end

  def path_fragments
    @fragments ||= @request.path.split("/").reject { |s| s.empty? }
  end
end
