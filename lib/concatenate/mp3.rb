# frozen_string_literal: true
require "colorize"

require_relative "mp3/version"

module Concatenate
  module Mp3
    class ConcatenateError < StandardError; end

    def files(*files)
      @mp3_files = []
    end

    def process
    end

    def is_mp3_file(file)
      File.open(file, "rb") do |f|
        header = f.read(4)
        f.rewind

        header == "ID3" || header.byteslice(0, 3) == "\xFF\xFB\x90"
      rescue StandardError
        false
      end
    end
  end
end
