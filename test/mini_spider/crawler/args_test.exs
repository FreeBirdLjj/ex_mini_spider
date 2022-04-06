defmodule MiniSpider.Crawler.ArgsTest do
  use MiniSpider.DataCase, async: true
  doctest MiniSpider.Crawler.Args

  describe "`encode_storage_params/2` and `decode_storage_params/2`" do
    test "`encode_storage_params/2` encodes, `decode_storage_params/2` decodes" do
      engine = :some_module
      opts = [opt1: :value1, opt2: :value2]

      assert {:ok, %{engine: ^engine, opts: ^opts}} =
               MiniSpider.Crawler.Args.encode_storage_params(engine, opts)
               |> Jason.encode!()
               |> Jason.decode!()
               |> MiniSpider.Crawler.Args.decode_storage_params()
    end
  end
end
