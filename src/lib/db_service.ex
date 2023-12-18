defmodule DbService do
  @moduledoc false

  alias DbService.Cache
  require Logger

  @threads 150

  @doc false
  def drop_table_test do
    MyXQL.query!(:myxql, "DROP TABLE IF EXISTS `hsa1016`.`test`;")
  end

  @doc false
  def create_test_table do
    MyXQL.query!(:myxql, "
      CREATE TABLE IF NOT EXISTS `hsa1016`.`test` (
        `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `rand_string` CHAR(36) NOT NULL,
        PRIMARY KEY (`id`));
    ")
  end

  @doc false
  def insert_record_into_table() do
    MyXQL.query!(:myxql, "
      INSERT INTO `hsa1016`.`test` (`rand_string`) VALUES ('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}'),('#{UUID.uuid4()}');
    ")
  end

  @doc false
  def select_record_from_table_by_string() do
    MyXQL.query!(:myxql, "
      SELECT * FROM `hsa1016`.`test` where `rand_string` = '#{UUID.uuid4()}';
    ")
  end

  @doc false
  def select_record_from_table_by_id() do
    MyXQL.query!(:myxql, "
      SELECT * FROM `hsa1016`.`test` where `id` = #{Enum.random(0..7_000_000)};
    ")
  end

  def start() do
    # drop_table_test()
    # create_test_table()
    write_time()
    make_requests()
  end

  defp write_time() do
    File.open("./time.txt", [:write], fn file ->
      IO.write(file, DateTime.utc_now())
    end)
  end

  @doc false
  def make_requests(threads \\ @threads) do
    if threads > 0 do
      Enum.each(1..threads, fn _ ->
        Task.Supervisor.start_child(DbService.TaskSupervisor, fn ->
          case select_record_from_table_by_id() do
            %MyXQL.Result{} ->
              requests = Cache.increment()
              Logger.info("requests: #{requests}")

              if requests == 100_000 do
                write_time()
              end

            error ->
              Logger.error(inspect(error))
          end
        end)
      end)
    end

    count = length(Task.Supervisor.children(DbService.TaskSupervisor))

    if count < @threads do
      make_requests(@threads - count)
    else
      make_requests(0)
    end
  end
end
