require 'net/http'
require 'json'

module Nagios3
  
  class ServiceProcessor
    def run
      perfdata = parse_files
      send_data(perfdata)
    end
    
  private    
    def parse_files
      entries, perfdata = perfdata_files, []
      entries.each do |entry|
        lines = File.readlines(entry)
        File.open(entry, "w") # clear file
        lines.each do |line|
          perfdata << parse(line)
        end
      end
      perfdata
    end
    
    def perfdata_files
      d = Dir.new(File.dirname(Nagios3.service_perfdata_path))
      entries = d.entries
      entries.delete_if { |entry| !(entry =~ /^service-perfdata/) }
      entries.map! { |entry| File.join(d.path, entry) }
      entries.sort
    end
    
    def send_data(perfdata)
      uri = URI.parse(Nagios3.service_perfdata_url)
      body = perfdata.to_json
      headers = {
        'Content-Type' => 'application/json',
        'Content-Length' => body.size.to_s
      }
      
      request = Net::HTTP::Post.new(uri.path, headers)
      http = Net::HTTP.new(uri.host, uri.port)
      
      timeout(10) do
        response = http.request(request, body)
      end
    end
    
    def parse(line)
      if line =~ /^\[SERVICEPERFDATA\]([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)$/
        perf_hash = { 
          :time => $1, :id => $2, :host => $3, :service => $4, :status => $5,
          :execution_time => $6, :latency => $7, :output => $8,
          :perfdata => $9
        }
      end
    end
    
  end
  
end