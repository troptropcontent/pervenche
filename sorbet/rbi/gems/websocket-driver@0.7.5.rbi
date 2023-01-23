# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `websocket-driver` gem.
# Please instead update this file by running `bin/tapioca gem websocket-driver`.

# source://websocket-driver//lib/websocket/driver.rb#16
module WebSocket
  class << self
    # source://websocket/1.2.9/lib/websocket.rb#20
    def max_frame_size; end

    # source://websocket/1.2.9/lib/websocket.rb#25
    def max_frame_size=(val); end

    # source://websocket/1.2.9/lib/websocket.rb#31
    def should_raise; end

    # source://websocket/1.2.9/lib/websocket.rb#36
    def should_raise=(val); end
  end
end

# source://websocket/1.2.9/lib/websocket.rb#10
WebSocket::DEFAULT_VERSION = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver.rb#19
class WebSocket::Driver
  include ::WebSocket::Driver::EventEmitter

  # @return [Driver] a new instance of Driver
  #
  # source://websocket-driver//lib/websocket/driver.rb#71
  def initialize(socket, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver.rb#89
  def add_extension(extension); end

  # source://websocket-driver//lib/websocket/driver.rb#122
  def binary(message); end

  # source://websocket-driver//lib/websocket/driver.rb#134
  def close(reason = T.unsafe(nil), code = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver.rb#126
  def ping(*args); end

  # source://websocket-driver//lib/websocket/driver.rb#130
  def pong(*args); end

  # Returns the value of attribute protocol.
  #
  # source://websocket-driver//lib/websocket/driver.rb#69
  def protocol; end

  # Returns the value of attribute ready_state.
  #
  # source://websocket-driver//lib/websocket/driver.rb#69
  def ready_state; end

  # source://websocket-driver//lib/websocket/driver.rb#93
  def set_header(name, value); end

  # source://websocket-driver//lib/websocket/driver.rb#99
  def start; end

  # source://websocket-driver//lib/websocket/driver.rb#84
  def state; end

  # source://websocket-driver//lib/websocket/driver.rb#117
  def text(message); end

  private

  # source://websocket-driver//lib/websocket/driver.rb#155
  def fail(type, message); end

  # source://websocket-driver//lib/websocket/driver.rb#143
  def fail_handshake(error); end

  # source://websocket-driver//lib/websocket/driver.rb#161
  def open; end

  # source://websocket-driver//lib/websocket/driver.rb#168
  def queue(message); end

  class << self
    # source://websocket-driver//lib/websocket/driver.rb#173
    def client(socket, options = T.unsafe(nil)); end

    # source://websocket-driver//lib/websocket/driver.rb#197
    def encode(data, encoding = T.unsafe(nil)); end

    # source://websocket-driver//lib/websocket/driver.rb#181
    def rack(socket, options = T.unsafe(nil)); end

    # source://websocket-driver//lib/websocket/driver.rb#177
    def server(socket, options = T.unsafe(nil)); end

    # source://websocket-driver//lib/websocket/driver.rb#212
    def validate_options(options, valid_keys); end

    # @return [Boolean]
    #
    # source://websocket-driver//lib/websocket/driver.rb#220
    def websocket?(env); end
  end
end

# source://websocket-driver//lib/websocket/driver/client.rb#4
class WebSocket::Driver::Client < ::WebSocket::Driver::Hybi
  # @return [Client] a new instance of Client
  #
  # source://websocket-driver//lib/websocket/driver/client.rb#13
  def initialize(socket, options = T.unsafe(nil)); end

  # Returns the value of attribute headers.
  #
  # source://websocket-driver//lib/websocket/driver/client.rb#11
  def headers; end

  # source://websocket-driver//lib/websocket/driver/client.rb#61
  def parse(chunk); end

  # source://websocket-driver//lib/websocket/driver/client.rb#50
  def proxy(origin, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/client.rb#54
  def start; end

  # Returns the value of attribute status.
  #
  # source://websocket-driver//lib/websocket/driver/client.rb#11
  def status; end

  # source://websocket-driver//lib/websocket/driver/client.rb#46
  def version; end

  private

  # source://websocket-driver//lib/websocket/driver/client.rb#87
  def fail_handshake(message); end

  # source://websocket-driver//lib/websocket/driver/client.rb#78
  def handshake_request; end

  # source://websocket-driver//lib/websocket/driver/client.rb#94
  def validate_handshake; end

  class << self
    # source://websocket-driver//lib/websocket/driver/client.rb#7
    def generate_key; end
  end
end

# source://websocket-driver//lib/websocket/driver/client.rb#5
WebSocket::Driver::Client::VALID_SCHEMES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver.rb#52
class WebSocket::Driver::CloseEvent < ::Struct
  # Returns the value of attribute code
  #
  # @return [Object] the current value of code
  def code; end

  # Sets the attribute code
  #
  # @param value [Object] the value to set the attribute code to.
  # @return [Object] the newly set value
  #
  # source://websocket-driver//lib/websocket/driver.rb#52
  def code=(_); end

  # Returns the value of attribute reason
  #
  # @return [Object] the current value of reason
  def reason; end

  # Sets the attribute reason
  #
  # @param value [Object] the value to set the attribute reason to.
  # @return [Object] the newly set value
  #
  # source://websocket-driver//lib/websocket/driver.rb#52
  def reason=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver.rb#56
class WebSocket::Driver::ConfigurationError < ::ArgumentError; end

# source://websocket-driver//lib/websocket/driver.rb#47
class WebSocket::Driver::ConnectEvent < ::Struct
  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver/draft75.rb#4
class WebSocket::Driver::Draft75 < ::WebSocket::Driver
  # @return [Draft75] a new instance of Draft75
  #
  # source://websocket-driver//lib/websocket/driver/draft75.rb#5
  def initialize(socket, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/draft75.rb#21
  def close(reason = T.unsafe(nil), code = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/draft75.rb#73
  def frame(buffer, type = T.unsafe(nil), error_type = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/draft75.rb#28
  def parse(chunk); end

  # source://websocket-driver//lib/websocket/driver/draft75.rb#17
  def version; end

  private

  # source://websocket-driver//lib/websocket/driver/draft75.rb#82
  def handshake_response; end

  # source://websocket-driver//lib/websocket/driver/draft75.rb#88
  def parse_leading_byte(octet); end
end

# source://websocket-driver//lib/websocket/driver/draft76.rb#4
class WebSocket::Driver::Draft76 < ::WebSocket::Driver::Draft75
  # @return [Draft76] a new instance of Draft76
  #
  # source://websocket-driver//lib/websocket/driver/draft76.rb#7
  def initialize(socket, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#31
  def close(reason = T.unsafe(nil), code = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#25
  def start; end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#21
  def version; end

  private

  # @raise [ProtocolError]
  #
  # source://websocket-driver//lib/websocket/driver/draft76.rb#41
  def handshake_response; end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#66
  def handshake_signature; end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#88
  def number_from_key(key); end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#81
  def parse_leading_byte(octet); end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#73
  def send_handshake_body; end

  # source://websocket-driver//lib/websocket/driver/draft76.rb#93
  def spaces_in_key(key); end
end

# source://websocket-driver//lib/websocket/driver/draft76.rb#5
WebSocket::Driver::Draft76::BODY_SIZE = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/event_emitter.rb#4
module WebSocket::Driver::EventEmitter
  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#5
  def initialize; end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#9
  def add_listener(event, callable = T.unsafe(nil), &block); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#37
  def emit(event, *args); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#43
  def listener_count(event); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#48
  def listeners(event); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#15
  def on(event, callable = T.unsafe(nil), &block); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#29
  def remove_all_listeners(event = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/event_emitter.rb#23
  def remove_listener(event, callable = T.unsafe(nil), &block); end
end

# source://websocket-driver//lib/websocket/driver/headers.rb#4
class WebSocket::Driver::Headers
  # @return [Headers] a new instance of Headers
  #
  # source://websocket-driver//lib/websocket/driver/headers.rb#7
  def initialize(received = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/headers.rb#20
  def [](name); end

  # source://websocket-driver//lib/websocket/driver/headers.rb#24
  def []=(name, value); end

  # source://websocket-driver//lib/websocket/driver/headers.rb#15
  def clear; end

  # source://websocket-driver//lib/websocket/driver/headers.rb#31
  def inspect; end

  # source://websocket-driver//lib/websocket/driver/headers.rb#35
  def to_h; end

  # source://websocket-driver//lib/websocket/driver/headers.rb#39
  def to_s; end
end

# source://websocket-driver//lib/websocket/driver/headers.rb#5
WebSocket::Driver::Headers::ALLOWED_DUPLICATES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/hybi.rb#4
class WebSocket::Driver::Hybi < ::WebSocket::Driver
  # @return [Hybi] a new instance of Hybi
  #
  # source://websocket-driver//lib/websocket/driver/hybi.rb#57
  def initialize(socket, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#84
  def add_extension(extension); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#127
  def binary(message); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#140
  def close(reason = T.unsafe(nil), code = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#157
  def frame(buffer, type = T.unsafe(nil), code = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#89
  def parse(chunk); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#131
  def ping(message = T.unsafe(nil), &callback); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#136
  def pong(message = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#80
  def version; end

  private

  # source://websocket-driver//lib/websocket/driver/hybi.rb#334
  def check_frame_length; end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#345
  def emit_frame(buffer); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#393
  def emit_message; end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#268
  def fail(type, message); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#230
  def handshake_response; end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#323
  def parse_extended_length(buffer); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#306
  def parse_length(octet); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#273
  def parse_opcode(octet); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#194
  def send_frame(frame); end

  # source://websocket-driver//lib/websocket/driver/hybi.rb#256
  def shutdown(code, reason, error = T.unsafe(nil)); end

  class << self
    # source://websocket-driver//lib/websocket/driver/hybi.rb#10
    def generate_accept(key); end
  end
end

# source://websocket-driver//lib/websocket/driver/hybi.rb#17
WebSocket::Driver::Hybi::BYTE = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#51
WebSocket::Driver::Hybi::DEFAULT_ERROR_CODE = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#38
WebSocket::Driver::Hybi::ERRORS = T.let(T.unsafe(nil), Hash)

# source://websocket-driver//lib/websocket/driver/hybi.rb#50
WebSocket::Driver::Hybi::ERROR_CODES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/hybi.rb#18
WebSocket::Driver::Hybi::FIN = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi/frame.rb#5
class WebSocket::Driver::Hybi::Frame
  # Returns the value of attribute final.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def final; end

  # Sets the attribute final
  #
  # @param value the value to set the attribute final to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def final=(_arg0); end

  # Returns the value of attribute length.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def length; end

  # Sets the attribute length
  #
  # @param value the value to set the attribute length to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def length=(_arg0); end

  # Returns the value of attribute length_bytes.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def length_bytes; end

  # Sets the attribute length_bytes
  #
  # @param value the value to set the attribute length_bytes to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def length_bytes=(_arg0); end

  # Returns the value of attribute masked.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def masked; end

  # Sets the attribute masked
  #
  # @param value the value to set the attribute masked to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def masked=(_arg0); end

  # Returns the value of attribute masking_key.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def masking_key; end

  # Sets the attribute masking_key
  #
  # @param value the value to set the attribute masking_key to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def masking_key=(_arg0); end

  # Returns the value of attribute opcode.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def opcode; end

  # Sets the attribute opcode
  #
  # @param value the value to set the attribute opcode to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def opcode=(_arg0); end

  # Returns the value of attribute payload.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def payload; end

  # Sets the attribute payload
  #
  # @param value the value to set the attribute payload to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def payload=(_arg0); end

  # Returns the value of attribute rsv1.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv1; end

  # Sets the attribute rsv1
  #
  # @param value the value to set the attribute rsv1 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv1=(_arg0); end

  # Returns the value of attribute rsv2.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv2; end

  # Sets the attribute rsv2
  #
  # @param value the value to set the attribute rsv2 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv2=(_arg0); end

  # Returns the value of attribute rsv3.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv3; end

  # Sets the attribute rsv3
  #
  # @param value the value to set the attribute rsv3 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/frame.rb#6
  def rsv3=(_arg0); end
end

# source://websocket-driver//lib/websocket/driver/hybi.rb#15
WebSocket::Driver::Hybi::GUID = T.let(T.unsafe(nil), String)

# source://websocket-driver//lib/websocket/driver/hybi.rb#23
WebSocket::Driver::Hybi::LENGTH = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#18
WebSocket::Driver::Hybi::MASK = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#53
WebSocket::Driver::Hybi::MAX_RESERVED_ERROR = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#35
WebSocket::Driver::Hybi::MESSAGE_OPCODES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/hybi.rb#52
WebSocket::Driver::Hybi::MIN_RESERVED_ERROR = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi/message.rb#5
class WebSocket::Driver::Hybi::Message
  # @return [Message] a new instance of Message
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#12
  def initialize; end

  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#20
  def <<(frame); end

  # Returns the value of attribute data.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def data; end

  # Sets the attribute data
  #
  # @param value the value to set the attribute data to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def data=(_arg0); end

  # Returns the value of attribute opcode.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def opcode; end

  # Sets the attribute opcode
  #
  # @param value the value to set the attribute opcode to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def opcode=(_arg0); end

  # Returns the value of attribute rsv1.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv1; end

  # Sets the attribute rsv1
  #
  # @param value the value to set the attribute rsv1 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv1=(_arg0); end

  # Returns the value of attribute rsv2.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv2; end

  # Sets the attribute rsv2
  #
  # @param value the value to set the attribute rsv2 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv2=(_arg0); end

  # Returns the value of attribute rsv3.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv3; end

  # Sets the attribute rsv3
  #
  # @param value the value to set the attribute rsv3 to.
  #
  # source://websocket-driver//lib/websocket/driver/hybi/message.rb#6
  def rsv3=(_arg0); end
end

# source://websocket-driver//lib/websocket/driver/hybi.rb#22
WebSocket::Driver::Hybi::OPCODE = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#25
WebSocket::Driver::Hybi::OPCODES = T.let(T.unsafe(nil), Hash)

# source://websocket-driver//lib/websocket/driver/hybi.rb#34
WebSocket::Driver::Hybi::OPCODE_CODES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/hybi.rb#36
WebSocket::Driver::Hybi::OPENING_OPCODES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/hybi.rb#55
WebSocket::Driver::Hybi::PACK_FORMATS = T.let(T.unsafe(nil), Hash)

# source://websocket-driver//lib/websocket/driver/hybi.rb#19
WebSocket::Driver::Hybi::RSV1 = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#20
WebSocket::Driver::Hybi::RSV2 = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#21
WebSocket::Driver::Hybi::RSV3 = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver/hybi.rb#14
WebSocket::Driver::Hybi::VERSION = T.let(T.unsafe(nil), String)

# source://websocket-driver//lib/websocket/driver.rb#44
WebSocket::Driver::MAX_LENGTH = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver.rb#49
class WebSocket::Driver::MessageEvent < ::Struct
  # Returns the value of attribute data
  #
  # @return [Object] the current value of data
  def data; end

  # Sets the attribute data
  #
  # @param value [Object] the value to set the attribute data to.
  # @return [Object] the newly set value
  #
  # source://websocket-driver//lib/websocket/driver.rb#49
  def data=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver.rb#48
class WebSocket::Driver::OpenEvent < ::Struct
  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver.rb#50
class WebSocket::Driver::PingEvent < ::Struct
  # Returns the value of attribute data
  #
  # @return [Object] the current value of data
  def data; end

  # Sets the attribute data
  #
  # @param value [Object] the value to set the attribute data to.
  # @return [Object] the newly set value
  #
  # source://websocket-driver//lib/websocket/driver.rb#50
  def data=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver.rb#51
class WebSocket::Driver::PongEvent < ::Struct
  # Returns the value of attribute data
  #
  # @return [Object] the current value of data
  def data; end

  # Sets the attribute data
  #
  # @param value [Object] the value to set the attribute data to.
  # @return [Object] the newly set value
  #
  # source://websocket-driver//lib/websocket/driver.rb#51
  def data=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

# source://websocket-driver//lib/websocket/driver.rb#54
class WebSocket::Driver::ProtocolError < ::StandardError; end

# source://websocket-driver//lib/websocket/driver/proxy.rb#4
class WebSocket::Driver::Proxy
  include ::WebSocket::Driver::EventEmitter

  # @return [Proxy] a new instance of Proxy
  #
  # source://websocket-driver//lib/websocket/driver/proxy.rb#11
  def initialize(client, origin, options); end

  # Returns the value of attribute headers.
  #
  # source://websocket-driver//lib/websocket/driver/proxy.rb#9
  def headers; end

  # source://websocket-driver//lib/websocket/driver/proxy.rb#51
  def parse(chunk); end

  # source://websocket-driver//lib/websocket/driver/proxy.rb#33
  def set_header(name, value); end

  # source://websocket-driver//lib/websocket/driver/proxy.rb#39
  def start; end

  # Returns the value of attribute status.
  #
  # source://websocket-driver//lib/websocket/driver/proxy.rb#9
  def status; end
end

# source://websocket-driver//lib/websocket/driver/proxy.rb#7
WebSocket::Driver::Proxy::PORTS = T.let(T.unsafe(nil), Hash)

# source://websocket-driver//lib/websocket/driver.rb#45
WebSocket::Driver::STATES = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/server.rb#4
class WebSocket::Driver::Server < ::WebSocket::Driver
  # @return [Server] a new instance of Server
  #
  # source://websocket-driver//lib/websocket/driver/server.rb#7
  def initialize(socket, options = T.unsafe(nil)); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def add_extension(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def binary(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def close(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#13
  def env; end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def frame(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#43
  def parse(chunk); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def ping(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#38
  def protocol; end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def set_header(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def start(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#27
  def text(*args, &block); end

  # source://websocket-driver//lib/websocket/driver/server.rb#17
  def url; end

  # source://websocket-driver//lib/websocket/driver/server.rb#38
  def version; end

  # source://websocket-driver//lib/websocket/driver/server.rb#60
  def write(buffer); end

  private

  # source://websocket-driver//lib/websocket/driver/server.rb#66
  def fail_request(message); end

  # source://websocket-driver//lib/websocket/driver/server.rb#71
  def open; end
end

# source://websocket-driver//lib/websocket/driver/server.rb#5
WebSocket::Driver::Server::EVENTS = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/driver/stream_reader.rb#4
class WebSocket::Driver::StreamReader
  # @return [StreamReader] a new instance of StreamReader
  #
  # source://websocket-driver//lib/websocket/driver/stream_reader.rb#8
  def initialize; end

  # source://websocket-driver//lib/websocket/driver/stream_reader.rb#30
  def each_byte; end

  # source://websocket-driver//lib/websocket/driver/stream_reader.rb#13
  def put(chunk); end

  # Read bytes from the data:
  #
  # source://websocket-driver//lib/websocket/driver/stream_reader.rb#19
  def read(length); end

  private

  # source://websocket-driver//lib/websocket/driver/stream_reader.rb#41
  def prune; end
end

# Try to minimise the number of reallocations done:
#
# source://websocket-driver//lib/websocket/driver/stream_reader.rb#6
WebSocket::Driver::StreamReader::MINIMUM_AUTOMATIC_PRUNE_OFFSET = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/driver.rb#55
class WebSocket::Driver::URIError < ::ArgumentError; end

# source://websocket-driver//lib/websocket/http.rb#2
module WebSocket::HTTP
  class << self
    # source://websocket-driver//lib/websocket/http.rb#10
    def normalize_header(name); end
  end
end

# source://websocket-driver//lib/websocket/http/headers.rb#4
module WebSocket::HTTP::Headers
  # source://websocket-driver//lib/websocket/http/headers.rb#40
  def initialize; end

  # @return [Boolean]
  #
  # source://websocket-driver//lib/websocket/http/headers.rb#47
  def complete?; end

  # @return [Boolean]
  #
  # source://websocket-driver//lib/websocket/http/headers.rb#51
  def error?; end

  # Returns the value of attribute headers.
  #
  # source://websocket-driver//lib/websocket/http/headers.rb#38
  def headers; end

  # source://websocket-driver//lib/websocket/http/headers.rb#55
  def parse(chunk); end

  private

  # source://websocket-driver//lib/websocket/http/headers.rb#84
  def complete; end

  # source://websocket-driver//lib/websocket/http/headers.rb#88
  def error; end

  # source://websocket-driver//lib/websocket/http/headers.rb#92
  def header_line(line); end

  # source://websocket-driver//lib/websocket/http/headers.rb#106
  def string_buffer; end
end

# source://websocket-driver//lib/websocket/http/headers.rb#6
WebSocket::HTTP::Headers::CR = T.let(T.unsafe(nil), Integer)

# RFC 2616 grammar rules:
#
#       CHAR           = <any US-ASCII character (octets 0 - 127)>
#
#       CTL            = <any US-ASCII control character
#                        (octets 0 - 31) and DEL (127)>
#
#       SP             = <US-ASCII SP, space (32)>
#
#       HT             = <US-ASCII HT, horizontal-tab (9)>
#
#       token          = 1*<any CHAR except CTLs or separators>
#
#       separators     = "(" | ")" | "<" | ">" | "@"
#                      | "," | ";" | ":" | "\" | <">
#                      | "/" | "[" | "]" | "?" | "="
#                      | "{" | "}" | SP | HT
#
# Or, as redefined in RFC 7230:
#
#       token          = 1*tchar
#
#       tchar          = "!" / "#" / "$" / "%" / "&" / "'" / "*"
#                      / "+" / "-" / "." / "^" / "_" / "`" / "|" / "~"
#                      / DIGIT / ALPHA
#                      ; any VCHAR, except delimiters
#
# source://websocket-driver//lib/websocket/http/headers.rb#36
WebSocket::HTTP::Headers::HEADER_LINE = T.let(T.unsafe(nil), Regexp)

# source://websocket-driver//lib/websocket/http/headers.rb#7
WebSocket::HTTP::Headers::LF = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/http/headers.rb#5
WebSocket::HTTP::Headers::MAX_LINE_LENGTH = T.let(T.unsafe(nil), Integer)

# source://websocket-driver//lib/websocket/http/request.rb#4
class WebSocket::HTTP::Request
  include ::WebSocket::HTTP::Headers

  # Returns the value of attribute env.
  #
  # source://websocket-driver//lib/websocket/http/request.rb#11
  def env; end

  private

  # source://websocket-driver//lib/websocket/http/request.rb#29
  def complete; end

  # source://websocket-driver//lib/websocket/http/request.rb#15
  def start_line(line); end
end

# source://websocket-driver//lib/websocket/http/request.rb#7
WebSocket::HTTP::Request::REQUEST_LINE = T.let(T.unsafe(nil), Regexp)

# source://websocket-driver//lib/websocket/http/request.rb#8
WebSocket::HTTP::Request::REQUEST_TARGET = T.let(T.unsafe(nil), Regexp)

# source://websocket-driver//lib/websocket/http/request.rb#9
WebSocket::HTTP::Request::RESERVED_HEADERS = T.let(T.unsafe(nil), Array)

# source://websocket-driver//lib/websocket/http/response.rb#4
class WebSocket::HTTP::Response
  include ::WebSocket::HTTP::Headers

  # source://websocket-driver//lib/websocket/http/response.rb#11
  def [](name); end

  # source://websocket-driver//lib/websocket/http/response.rb#15
  def body; end

  # Returns the value of attribute code.
  #
  # source://websocket-driver//lib/websocket/http/response.rb#9
  def code; end

  private

  # source://websocket-driver//lib/websocket/http/response.rb#21
  def start_line(line); end
end

# source://websocket-driver//lib/websocket/http/response.rb#7
WebSocket::HTTP::Response::STATUS_LINE = T.let(T.unsafe(nil), Regexp)

module WebSocket::Mask
  class << self
    def mask(_arg0, _arg1); end
  end
end

# source://websocket/1.2.9/lib/websocket.rb#11
WebSocket::ROOT = T.let(T.unsafe(nil), String)
