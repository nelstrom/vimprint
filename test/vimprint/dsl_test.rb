require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/dsl'

module Vimprint
  describe Dsl do
    it 'has a motion method' do
      Dsl.parse do
        motion {
          trigger 'h'
          explain {
            template 'move right #{number}'
            number {
              singular "1 character"
              plural '#{count} characters'
            }
          }
        }
      end
      normal_mode = Registry.get_mode("normal")
      h_once = normal_mode.get_command({trigger: 'h', number: 'singular'})
      h_multiple = normal_mode.get_command({trigger: 'h', number: 'plural'})
      assert_equal Explanation, h_once.class
      assert_equal "move right 1 character", h_once.template
      assert_equal Explanation, h_multiple.class
      assert_equal 'move right #{count} characters', h_multiple.template
    end
  end
end
