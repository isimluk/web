defmodule Trento.Hosts do
  @moduledoc """
  Provides a set of functions to interact with hosts.
  """

  import Ecto.Query

  alias Trento.{
    Heartbeat,
    HostReadModel,
    Repo,
    SlesSubscriptionReadModel
  }

  alias Trento.Support.DateService

  alias Trento.Domain.Commands.RequestHostDeregistration

  @heartbeat_interval Application.compile_env!(:trento, __MODULE__)[:interval]

  @spec get_all_hosts :: [HostReadModel.t()]
  def get_all_hosts do
    HostReadModel
    |> where([h], not is_nil(h.hostname) and is_nil(h.deregistered_at))
    |> order_by(asc: :hostname)
    |> Repo.all()
    |> Repo.preload([:sles_subscriptions, :tags])
  end

  @spec get_all_sles_subscriptions :: non_neg_integer()
  def get_all_sles_subscriptions do
    query =
      from(s in SlesSubscriptionReadModel,
        where: s.identifier == "SLES_SAP",
        select: count()
      )

    case Repo.one(query) do
      nil ->
        0

      subscription_count ->
        subscription_count
    end
  end

  @spec deregister_host(String.t()) :: :ok | {:error, any}
  def deregister_host(host_id) do
    HostReadModel
    |> where([h], h.id == ^host_id)
    |> Repo.exists?()
    |> maybe_dispatch_host_deregistration_request(host_id)
  end

  defp commanded,
    do: Application.fetch_env!(:trento, Trento.Commanded)[:adapter]

  defp maybe_dispatch_host_deregistration_request(false, _) do
    {:error, :host_not_found}
  end

  defp maybe_dispatch_host_deregistration_request(true, date_service \\ DateService, host_id) do
    now = date_service.utc_now()

    query =
      from(h in Heartbeat,
        where:
          h.timestamp >
            ^DateTime.add(now, -@heartbeat_interval, :millisecond) and
            h.agent_id == ^host_id
      )

    unless Repo.exists?(query) do
      RequestHostDeregistration.new!(%{host_id: host_id, deregistered_at: now})
      |> commanded().dispatch()
    else
      {:error, :host_alive}
    end
  end
end
