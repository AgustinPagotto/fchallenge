class Router
  def initialize(request)
    @request = request
  end

  def route!
    #Static files before route to controllers
    return serve_openapi if @request.path == '/openapi.yaml'
    return serve_authors if @request.path == '/AUTHORS'

    if klass = controller_class
      add_route_info_to_request_params!

      controller = klass.new(@request)
      action = route_info[:action]

      if controller.respond_to?(action)
        puts "\nRouting to #{klass}##{action}"
        return controller.public_send(action)
      end
    end
    not_found
  end

  private

  def serve_openapi
    [
      200,
      {
        'Content-Type' => 'application/yaml',
        'Cache-Control' => 'no-store'
      },
      [File.read('openapi.yaml')]
    ]
  rescue Errno::ENOENT
    not_found
  end

  def serve_authors
    [
      200,
      {
        'Content-Type' => 'text/plain',
        'Cache-Control' => 'max-age=86400'
      },
      [File.read('AUTHORS')]
    ]
  rescue Errno::ENOENT
    not_found
  end

  def add_route_info_to_request_params!
    @request.params.merge!(route_info)
  end

  def not_found(msg = 'Not Found')
    [404, { 'Content-Type' => 'text/plain' }, [msg]]
  end

  # route info returns a hash with the "routing coordinates"
  # First element = resource
  # Second element = action to do (can be show, new, index or create depending of the http method
  # and the id
  # Third id if it exists
  def route_info
    @route_info ||= begin
      resource = path_fragments[0] || 'base'
      id, action = find_id_and_action(path_fragments[1])
      { resource: resource, action: action, id: id }
    end
  end

  def find_id_and_action(fragment)
    case fragment
    when 'new'
      [nil, :new]
    when nil
      action = @request.get? ? :index : :create
      [nil, action]
    else
      [fragment, :show]
    end
  end

  def path_fragments
    @fragments ||= @request.path.split('/').reject { |s| s.empty? }
  end

  def controller_name
    "#{route_info[:resource].capitalize}Controller"
  end

  # Returns the class of the controllers name
  def controller_class
    Object.const_get(controller_name)
  rescue NameError
    nil
  end
end
