class LogFormatter
  def call(severity, time, progname, msg)
    JSON.generate({ severity:, time:, progname:, msg: })
  end
end
