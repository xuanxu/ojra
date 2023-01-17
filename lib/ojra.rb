require_relative "ojra/client"
require_relative "ojra/version"

module OJRA
  class Error < StandardError; end
  class UnconfiguredAPI < Error; end
end