require "erb"

class CounterToObjectApp

  def initialize(*args)
    ObjectSpace.define_finalizer(self, method(:finalize))
    super
  end

  def finalize(object_id)

  end

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when "/home"
      Rack::Response.new(render("index.html.erb"))
    when "/countme"
      Rack::Response.new do |response|
        new_count = @request.cookies["count"].nil? ? 1 : @request.cookies["count"].to_i + 1
        response.set_cookie("count", new_count)
        store_counter_in_file(new_count)
        response.redirect("/home")
        #render("index.html.erb")
      end
    when "/lowerme"
      Rack::Response.new do |response|
        new_count = @request.cookies["count"].nil? ? 1 : @request.cookies["count"].to_i - 1
        response.set_cookie("count", new_count)
        store_counter_in_file(new_count)
        response.redirect("/home")
        #render("index.html.erb")
      end
    else Rack::Response.new("Not Found: Use /home ", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def count_cookie
    @request.cookies["count"] || "Something went wrong"
  end

  def store_counter_in_file(count_to_file)
    counter_file = File.new('counterfile.txt', 'w')
    counter_file.print "Page Refresh Count: "
    counter_file.puts count_to_file
    counter_file.close
  end
end
