module RequestHelper
  JSON_ACCEPT_HEADER = {
    'HTTP_ACCEPT' => 'application/json'
  }.freeze

  if Gem::Version.new(Rails.version) < Gem::Version.new('5')
    # Legacy Rails integration test helpers use positional arguments.
    def get_json(path, headers: {}, params: {})
      get(path, params, JSON_ACCEPT_HEADER.merge(headers))
    end
  else
    # Current Rails integration test helpers use named arguments.
    def get_json(path, headers: {}, params: {})
      get(path, {
        headers: JSON_ACCEPT_HEADER.merge(headers),
        params: params
      })
    end
  end
end
