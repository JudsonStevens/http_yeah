class Parser

  def retrieve_verb(request_lines)
    request_lines[0].split[0]
  end

  def retrieve_path(request_lines)
    request_lines[0].split[1]
  end

  def retrieve_protocol(request_lines)
    request_lines[0].split[2]
  end

  def retrieve_word_for_word_search(request_lines)
    retrieve_path(request_lines).split("?")[1].split("=")[1]
  end

  def retrieve_host(request_lines)
    split_array = split_array_into_smaller_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[0][0].split(":")[0]
  end

  def retrieve_port(request_lines)
    split_array = split_array_into_smaller_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[0][0].split(":")[1]
  end

  def retrieve_origin(request_lines)
    split_array = split_array_into_smaller_array(request_lines)
    result_array = return_location_port_array_from_host(split_array)
    result_array[0][0].split(":")[0]
  end

  def retrieve_accept(request_lines)
    split_array = split_array_into_smaller_array(request_lines)
    results_hash = request_lines_to_hash(split_array)
    results_hash["Accept"]
  end

  def split_array_into_smaller_array(request_lines)
    request_lines.map { |index| index.split(": ") }
  end

  def request_lines_to_hash(split_array)
    split_array.delete_if { |element| element[0] == "Host" }
    split_array.shift
    split_array.to_h
  end

  def return_location_port_array_from_host(split_array)
    host_array = split_array.map do |element|
      if element[0] == "Host"
        location = element[1]
        port = element[2]
        [location, port]
      end
    end
    host_array.compact
  end

  def return_word_validity(word)
    found_word = File.open('/usr/share/dict/words') do |file|
      file.grep(/#{word}/)
    end
    return false if found_word == []
    return true
  end
end
