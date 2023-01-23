# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `msgpack` gem.
# Please instead update this file by running `bin/tapioca gem msgpack`.

# source://msgpack//lib/msgpack/core_ext.rb#67
class Array
  include ::Enumerable
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#71
  def to_msgpack_with_packer(packer); end
end

# source://activesupport/7.0.4.1/lib/active_support/core_ext/array/deprecated_conversions.rb#4
Array::NOT_SET = T.let(T.unsafe(nil), Object)

Bignum = Integer

# source://msgpack//lib/msgpack/core_ext.rb#37
class FalseClass
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#41
  def to_msgpack_with_packer(packer); end
end

# source://msgpack//lib/msgpack/core_ext.rb#47
class Float < ::Numeric
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#51
  def to_msgpack_with_packer(packer); end
end

# source://msgpack//lib/msgpack/core_ext.rb#77
class Hash
  include ::Enumerable
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#81
  def to_msgpack_with_packer(packer); end
end

# Enhance the Integer class with a XML escaped character conversion.
#
# source://msgpack//lib/msgpack/core_ext.rb#98
class Integer < ::Numeric
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#102
  def to_msgpack_with_packer(packer); end
end

# MessagePack extention packer and unpacker for built-in Time class
#
# source://msgpack//lib/msgpack/version.rb#1
module MessagePack
  private

  # source://msgpack//lib/msgpack.rb#38
  def dump(v, io = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack.rb#21
  def load(src, param = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack.rb#38
  def pack(v, io = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack.rb#21
  def unpack(src, param = T.unsafe(nil)); end

  class << self
    # source://msgpack//lib/msgpack.rb#38
    def dump(v, io = T.unsafe(nil), options = T.unsafe(nil)); end

    # source://msgpack//lib/msgpack.rb#21
    def load(src, param = T.unsafe(nil)); end

    # source://msgpack//lib/msgpack.rb#38
    def pack(v, io = T.unsafe(nil), options = T.unsafe(nil)); end

    # source://msgpack//lib/msgpack.rb#21
    def unpack(src, param = T.unsafe(nil)); end
  end
end

# source://msgpack//lib/msgpack/core_ext.rb#2
module MessagePack::CoreExt
  # source://msgpack//lib/msgpack/core_ext.rb#3
  def to_msgpack(packer_or_io = T.unsafe(nil)); end
end

# source://msgpack//lib/msgpack/core_ext.rb#130
class MessagePack::ExtensionValue < ::Struct
  include ::MessagePack::CoreExt

  def payload=(_); end
  def type=(_); end

  private

  # source://msgpack//lib/msgpack/core_ext.rb#134
  def to_msgpack_with_packer(packer); end
end

# source://msgpack//lib/msgpack/factory.rb#2
class MessagePack::Factory
  # source://msgpack//lib/msgpack/factory.rb#74
  def dump(v, *rest); end

  # source://msgpack//lib/msgpack/factory.rb#60
  def load(src, param = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack/factory.rb#74
  def pack(v, *rest); end

  # source://msgpack//lib/msgpack/factory.rb#81
  def pool(size = T.unsafe(nil), **options); end

  # [ {type: id, class: Class(or nil), packer: arg, unpacker: arg}, ... ]
  #
  # source://msgpack//lib/msgpack/factory.rb#6
  def registered_types(selector = T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://msgpack//lib/msgpack/factory.rb#47
  def type_registered?(klass_or_type, selector = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack/factory.rb#60
  def unpack(src, param = T.unsafe(nil)); end
end

# source://msgpack//lib/msgpack/factory.rb#89
class MessagePack::Factory::Pool
  # @return [Pool] a new instance of Pool
  #
  # source://msgpack//lib/msgpack/factory.rb#156
  def initialize(factory, size, options = T.unsafe(nil)); end

  # source://msgpack//lib/msgpack/factory.rb#173
  def dump(object); end

  # source://msgpack//lib/msgpack/factory.rb#163
  def load(data); end
end

# source://msgpack//lib/msgpack/factory.rb#91
class MessagePack::Factory::Pool::AbstractPool
  # @return [AbstractPool] a new instance of AbstractPool
  #
  # source://msgpack//lib/msgpack/factory.rb#92
  def initialize(size, &block); end

  # source://msgpack//lib/msgpack/factory.rb#102
  def checkin(member); end

  # source://msgpack//lib/msgpack/factory.rb#98
  def checkout; end
end

# source://msgpack//lib/msgpack/factory.rb#140
class MessagePack::Factory::Pool::PackerPool < ::MessagePack::Factory::Pool::AbstractPool
  private

  # source://msgpack//lib/msgpack/factory.rb#143
  def reset(packer); end
end

# source://msgpack//lib/msgpack/factory.rb#148
class MessagePack::Factory::Pool::UnpackerPool < ::MessagePack::Factory::Pool::AbstractPool
  private

  # source://msgpack//lib/msgpack/factory.rb#151
  def reset(unpacker); end
end

# source://msgpack//lib/msgpack/packer.rb#2
class MessagePack::Packer
  # see ext for other methods
  #
  # source://msgpack//lib/msgpack/packer.rb#5
  def registered_types; end

  # @return [Boolean]
  #
  # source://msgpack//lib/msgpack/packer.rb#15
  def type_registered?(klass_or_type); end
end

# source://msgpack//lib/msgpack/time.rb#5
module MessagePack::Time; end

# source://msgpack//lib/msgpack/time.rb#25
MessagePack::Time::Packer = T.let(T.unsafe(nil), Proc)

# 3-arg Time.at is available Ruby >= 2.5
#
# source://msgpack//lib/msgpack/time.rb#7
MessagePack::Time::TIME_AT_3_AVAILABLE = T.let(T.unsafe(nil), TrueClass)

# source://msgpack//lib/msgpack/time.rb#13
MessagePack::Time::Unpacker = T.let(T.unsafe(nil), Proc)

# a.k.a. "TimeSpec"
#
# source://msgpack//lib/msgpack/timestamp.rb#4
class MessagePack::Timestamp
  # @param sec [Integer]
  # @param nsec [Integer]
  # @return [Timestamp] a new instance of Timestamp
  #
  # source://msgpack//lib/msgpack/timestamp.rb#24
  def initialize(sec, nsec); end

  # source://msgpack//lib/msgpack/timestamp.rb#72
  def ==(other); end

  # @return [Integer]
  #
  # source://msgpack//lib/msgpack/timestamp.rb#20
  def nsec; end

  # @return [Integer]
  #
  # source://msgpack//lib/msgpack/timestamp.rb#17
  def sec; end

  # source://msgpack//lib/msgpack/timestamp.rb#68
  def to_msgpack_ext; end

  class << self
    # source://msgpack//lib/msgpack/timestamp.rb#29
    def from_msgpack_ext(data); end

    # source://msgpack//lib/msgpack/timestamp.rb#50
    def to_msgpack_ext(sec, nsec); end
  end
end

# source://msgpack//lib/msgpack/timestamp.rb#13
MessagePack::Timestamp::TIMESTAMP32_MAX_SEC = T.let(T.unsafe(nil), Integer)

# source://msgpack//lib/msgpack/timestamp.rb#14
MessagePack::Timestamp::TIMESTAMP64_MAX_SEC = T.let(T.unsafe(nil), Integer)

# The timestamp extension type defined in the MessagePack spec.
# See https://github.com/msgpack/msgpack/blob/master/spec.md#timestamp-extension-type for details.
#
# source://msgpack//lib/msgpack/timestamp.rb#11
MessagePack::Timestamp::TYPE = T.let(T.unsafe(nil), Integer)

class MessagePack::UnexpectedTypeError < ::MessagePack::UnpackError
  include ::MessagePack::TypeError
end

# source://msgpack//lib/msgpack/unpacker.rb#2
class MessagePack::Unpacker
  # see ext for other methods
  #
  # source://msgpack//lib/msgpack/unpacker.rb#5
  def registered_types; end

  # @return [Boolean]
  #
  # source://msgpack//lib/msgpack/unpacker.rb#15
  def type_registered?(klass_or_type); end
end

# source://msgpack//lib/msgpack/core_ext.rb#17
class NilClass
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#21
  def to_msgpack_with_packer(packer); end
end

# Enhance the String class with a XML escaped character version of
# to_s.
#
# source://msgpack//lib/msgpack/core_ext.rb#57
class String
  include ::Comparable
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#61
  def to_msgpack_with_packer(packer); end
end

# source://activesupport/7.0.4.1/lib/active_support/core_ext/object/blank.rb#104
String::BLANK_RE = T.let(T.unsafe(nil), Regexp)

# source://activesupport/7.0.4.1/lib/active_support/core_ext/object/blank.rb#105
String::ENCODED_BLANKS = T.let(T.unsafe(nil), Concurrent::Map)

# source://msgpack//lib/msgpack/symbol.rb#1
class Symbol
  include ::Comparable
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#91
  def to_msgpack_with_packer(packer); end

  class << self
    # source://msgpack//lib/msgpack/symbol.rb#12
    def from_msgpack_ext(data); end
  end
end

# source://msgpack//lib/msgpack/core_ext.rb#27
class TrueClass
  include ::MessagePack::CoreExt

  private

  # source://msgpack//lib/msgpack/core_ext.rb#31
  def to_msgpack_with_packer(packer); end
end
