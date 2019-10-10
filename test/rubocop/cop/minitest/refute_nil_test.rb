# frozen_string_literal: true

require 'test_helper'

class RefuteNilTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteNil.new
  end

  def test_registers_offense_when_using_refute_equal_with_nil
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff)` over `refute_equal(nil, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_nil_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, 'the message')` over `refute_equal(nil, somestuff, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_a_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, obj.do_something, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(obj.do_something, 'the message')` over `refute_equal(nil, obj.do_something, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(obj.do_something, 'the message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_nil_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end
end
