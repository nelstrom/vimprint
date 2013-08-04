gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/dsl'

module Vimprint

  describe HashFromBlock do

    def values
      proc do
        one 1
        two 2
        nested do
          three 3
        end
      end
    end

    it '.new returns a HashFromBlock object' do
      builder = HashFromBlock.new &values
      assert_equal HashFromBlock, builder.class
      assert_equal({one: 1, two: 2, nested: {three: 3}}, builder.hash)
    end

    it 'can add new items' do
      builder = HashFromBlock.new { one 1 }
      builder.two 2
      assert_equal({one: 1, two: 2}, builder.hash)
    end

    it '.build returns a hash object' do
      hash = HashFromBlock.build &values
      assert_equal({one: 1, two: 2, nested: {three: 3}}, hash)
    end

  end

  describe Config do

    def config
      Config.new do
        trigger 'h'
        explain {
          template 'move right {{number}}'
          number {
            singular "1 character"
            plural '#{count} characters'
          }
        }
      end
    end

    it '#signature accesses the trigger' do
      assert_equal({trigger: "h"}, config.signature)
    end

    it '#template accesses the template' do
      assert_equal('move right {{number}}', config.template)
    end

    it '#projected_templates gets singular+plural templates' do
      templates = {
        :singular => "move right 1 character",
        :plural => 'move right #{count} characters',
      }
      assert_equal(templates, config.projected_templates)
    end

  end

  describe Dsl do
    it 'has a motion method' do
      Dsl.parse do
        motion {
          trigger 'h'
          explain {
            template 'move right {{number}}'
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
