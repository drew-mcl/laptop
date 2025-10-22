# frozen_string_literal: true

require "irb/completion"
require "irb/ext/save-history"
require "fileutils"

data_home =
  if (xdg = ENV["XDG_DATA_HOME"]) && !xdg.empty?
    File.join(xdg, "irb")
  else
    File.join(ENV.fetch("HOME", Dir.home), ".local", "share", "irb")
  end

FileUtils.mkdir_p(data_home)

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:HISTORY_FILE] = File.join(data_home, "history")
IRB.conf[:SAVE_HISTORY] = 2000
IRB.conf[:PROMPT_MODE] = :SIMPLE
