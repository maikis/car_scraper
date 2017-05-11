module CarStalker
  # Error which is raised in case any spec passed in is not supported.
  class UnsupportedSpecError < StandardError
    attr_reader :details

    def initialize(message = 'Unsupported spec.', details = {})
      @details = details
      super(message)
    end
  end
end
