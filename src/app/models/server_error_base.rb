class ServerErrorBase < StandardError
  def self.wrap(error)
    new("#{error.class}: #{error}").tap do |e|
      e.set_backtrace(error.backtrace)
    end
  end

  def self.define_error(name, code:, status:)
    define_error_class(name, code: code, status: status)
  end

  def self.define_error_class(name, code:, status:)
    klass = Class.new(self) do
      class_eval do
        define_method(:code) { code }
        define_method(:status) { status }
      end
    end

    const_set(name, klass)
  end
end
