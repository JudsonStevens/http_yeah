class Parser

  def initialize
    @request_hash = {}
  end

  def request_lines_to_hash(split_array)
    array_without_host = split_array.each do |element|
      if element[0] == "Host"
        element = nil
      end
    end
    array_without_host.to_h.compact
  end

  def split_array_into_mini_array(request_lines)
    request_lines.map { |index| index.split(": ") }
  end

  def retrieve_verb(request_lines)
    request_lines[0].split[0]
  end

  def retrieve_path(request_lines)
    request_lines[0].split[1]
  end

  def retrieve_protocol(request_lines)
    request_lines[0].split[2]
  end

  def retrieve_host(request_lines)
    split_array = split_array_into_mini_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[0]
  end

  def retrieve_port(request_lines)
    split_array = split_array_into_mini_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[1]
  end

  def retrieve_origin(request_lines)
    split_array = split_array_into_mini_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[0]
  end

  def retrieve_accept(request_lines)
    split_array = split_array_into_mini_array(request_lines)
    results_hash = request_lines_to_hash(split_array)
    results_hash["Accept"]
  end

  def return_location_port_array_from_host(split_array)
    host_array = @request_divided_array.map do |element|
      if element[0] == "Host"
        location = element[1]
        port = element[2]
        [location, port]
      end
    end
    host_array.compact
  end
end
