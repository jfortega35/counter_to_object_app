trace = TracePoint.new(:call) do |tp|
  if tp.path =~ /counter_to_object_app/
    puts [tp.method_id, tp.path.split('/').last, tp.lineno].inspect
  end

end

trace.enable

require "counter_to_object_app"

use Rack::Reloader, 0

run CounterToObjectApp.new



#run Rack::Cascade.new([Rack::File.new("public"), SettingCookiesApp])
