defmodule Trento.Rollup do
  @moduledoc """
  Provides the rollup functionality
  """

  def rollup_aggregate(aggregate_id, event) do
    {:ok, pid} = Postgrex.start_link(Trento.EventStore.config())

    Postgrex.transaction(pid, fn conn ->
      with :ok <- Trento.EventStore.delete_snapshot(aggregate_id, conn: conn),
           {:ok, _} <- archive_stream(conn, aggregate_id) do
        Trento.EventStore.append_to_stream(
          aggregate_id,
          :any_version,
          [
            %EventStore.EventData{
              causation_id: UUID.uuid4(),
              correlation_id: UUID.uuid4(),
              event_type: Commanded.EventStore.TypeProvider.to_string(event),
              data: %{event | applied: true},
              metadata: %{}
            }
          ],
          conn: conn
        )
      end
    end)
  end

  defp archive_stream(conn, stream_id) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    Postgrex.query(
      conn,
      "UPDATE streams SET stream_uuid = 'archived-#{stream_id}-#{now}' WHERE stream_uuid = '#{stream_id}';",
      []
    )
  end
end
