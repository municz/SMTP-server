require "eventmachine"

module SmtpServerHandler
 
  include EventMachine::Protocols::LineText2
 
  def post_init
    send_data("220 smtp.localhost ESMTP Temifix\n")
    initialize
  end
 
  def unbind
  end

  def initialize
    @recipients = []
    @sender = ""
    @data = ""
    @receiving_data = false
  end
 
  def receive_line(data)

    puts "C: " + data

    if !@receiving_data

      case data

        when /EHLO (.*)/
          send_data("250 Hello #{$1}, Keep the spirit!\r\n")

        when /MAIL FROM:(.*)/
          @sender = $1
          send_data("250 Ok\n")

        when /RCPT TO:(.*)/
          @recipients << $1
          send_data("250 Ok\r\n")

        when /DATA/
          send_data("354 End data with <CR><LF>.<CR><LF>\r\n")
          @receiving_data = true

        when /QUIT/
          send_data("221 Bye\r\n")
          close_connection_after_writing

      end

    else

      if data == "."
        send_data("250 Ok: queued\n")
        puts("#{@sender} -> #{@recipients}: #{@data}\n")
        initialize
      else
        @data << data + "\n"
      end

    end

  end
 
end
 
EventMachine.run do
 
  EventMachine.start_server("127.0.0.1", 3000, SmtpServerHandler)

end
