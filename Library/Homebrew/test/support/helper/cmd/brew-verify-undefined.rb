# typed: strict
# frozen_string_literal: true

require "cli/parser"

UNDEFINED_CONSTANTS = %w[
  Cask::Cask
  Formula
  Formulary
  Homebrew::API
  Tap
].freeze

module Homebrew
  module Cmd
    class VerifyUndefined < AbstractCommand
    end
  end
end

parser = Homebrew::CLI::Parser.new(Homebrew::Cmd::VerifyUndefined) do
  usage_banner <<~EOS
    `verify-undefined`

    Verifies that the following constants have not been defined
    at startup to make sure that startup times stay consistent.

    Contants:
    #{UNDEFINED_CONSTANTS.join("\n")}
  EOS
end

parser.parse

UNDEFINED_CONSTANTS.each do |constant_name|
  Object.const_get(constant_name)
  ofail "#{constant_name} should not be defined at startup"
rescue NameError
  # We expect this to error as it should not be defined.
end