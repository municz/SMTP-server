require "eventmachine"

module SmtpClient

  include EventMachine::Protocols::LineText2

  def post_init
    send_data("EHLO smtp\n")
    send_data("MAIL FROM: pepa@depa.cz\n")
    send_data("RCPT TO: neco@nekde.cz\n")
    send_data("DATA\n")
    send_data("data, data. data\n")
    send_data("nexo\n")
    send_data(".\n")

    send_data("MAIL FROM: pepa@depa.cz\n")
    send_data("RCPT TO: neco@nekde.cz\n")
    send_data("RCPT TO: neco2@nekde.cz\n")
    send_data("DATA\n")
    send_data("data, data. data\n")
    send_data("nexo\n")
    send_data(".\n")

    send_data("QUIT\n")
  end

  def receive_line(data)
    puts data
  end
end

EventMachine.run do

  EventMachine.connect("127.0.0.1", 3000, SmtpClient)

end
