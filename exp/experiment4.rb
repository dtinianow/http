require "socket"

hellos = 0
webserver = TCPServer.new(9292)
while (session = webserver.accept)
  session.print("Hello World! (#{hellos})")
  session.close
  hellos += 1
end
