# frozen_string_literal: true
require "rainbow"

require_relative "mp3/version"

module Concatenate
  module Mp3
    class ConcatenateError < StandardError; end

    def initialize
      @mp3_files = []
      @ffmpeg_options = {
        sampling_rate: "44100",
        audio_channels: "2",
        bitrate: "128k",
      }
    end

    def files(*files)
      files.each do |file|
        unless is_mp3_file(file)
          raise ConcatenateError, Rainbow("Invalid MP3 file: #{file}").red
        end
      end

      @mp3_files = files
    end

    def process(output_file, options = {})
      input_files = @mp3_files.join("|")
      temp_files = []

      begin
        @mp3_files.each do |file|
          temp_file = "#{file}_aux.mp3"
          command = build_ffmpeg_command(file, temp_file, options)
          execute_command(command)
          temp_files << temp_file
        end

        command = build_ffmpeg_concat_command(temp_files, output_file, options)
        execute_command(command)

        puts Rainbow("Concatenation successful!").green
        output_file
      ensure
        temp_files.each { |file| File.delete(file) if File.exist?(file) }
      end
    end

    private

    def build_ffmpeg_command(input_file, output_file, options)
      ar = options[:sampling_rate] || @ffmpeg_options[:sampling_rate]
      ac = options[:audio_channels] || @ffmpeg_options[:audio_channels]
      ab = options[:bitrate] || @ffmpeg_options[:bitrate]

      "ffmpeg -i #{input_file} -ar #{ar} -ac #{ac} -ab #{ab} #{output_file}"
    end

    def build_ffmpeg_concat_command(input_files, output_file, options)
      ar = options[:sampling_rate] || @ffmpeg_options[:sampling_rate]
      ac = options[:audio_channels] || @ffmpeg_options[:audio_channels]
      ab = options[:bitrate] || @ffmpeg_options[:bitrate]

      input_list = input_files.map { |file| "file '#{file}'" }.join("\n")
      concat_file = Tempfile.new("concat").path
      File.write(concat_file, input_list)

      "ffmpeg -f concat -safe 0 -i #{concat_file} -ar #{ar} -ac #{ac} -ab #{ab} #{output_file}"
    end

    def execute_command(command)
      puts Rainbow("Concatenating all mp3 files...").cyan
      result = system(command + " > /dev/null 2>&1")
      raise ConcatenateError, "Command execution failed" unless result
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
