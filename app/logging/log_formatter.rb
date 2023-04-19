module Logging
  class LogFormatter < Logger::Formatter
    def call(severity, time, progname, msg)
      JSON.generate({ severity:, time:, progname:, msg: })
    end
  end
end
