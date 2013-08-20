require './lib/vimprint/model/command_tree'

module Vimprint

  class BaseMode < Array
    extend Vimprint::ModeOpener
  end

  class NormalMode < BaseMode
  end

  class InsertMode < BaseMode
  end

  class VisualMode < BaseMode
  end

  class CmdlineMode < BaseMode
  end

end
