#!/usr/bin/ruby
require 'irb/completion'

# This is the old require location
# require 'irb/ext/save-history' rescue LoadError

# This is the modern require location
require 'irb/ext/eval_history'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

