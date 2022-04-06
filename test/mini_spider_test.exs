defmodule MiniSpiderTest do
  use ExUnit.Case
  doctest MiniSpider

  test "greets the world" do
    assert MiniSpider.hello() == :world
  end
end
