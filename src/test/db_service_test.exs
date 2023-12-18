defmodule DbServiceTest do
  use ExUnit.Case
  doctest DbService

  test "greets the world" do
    assert DbService.hello() == :world
  end
end
