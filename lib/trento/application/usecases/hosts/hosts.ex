defmodule Trento.Hosts do
  @moduledoc """
  Provides a set of functions to interact with hosts.
  """

  import Ecto.Query

  alias Trento.{
    HostReadModel,
    SlesSubscriptionReadModel
  }

  alias Trento.Repo

  alias Trento.Domain.Commands.RequestHostDeregistration

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
      from s in SlesSubscriptionReadModel,
        where: s.identifier == "SLES_SAP",
        select: count()

    case Repo.one(query) do
      nil ->
        0

      subscription_count ->
        subscription_count
    end
  end

  @spec deregister_host(String.t()) :: :ok | {:error, any}
  def deregister_host(host_id) do
    dat = DateTime.utc_now()

    target_host = HostReadModel
    |> where([h], h.id == ^host_id)
    |> Repo.one()

    IO.inspect("TARGET HOST: #{inspect(target_host)}")

    if target_host == nil do
      IO.inspect("TARGET HOST IS NIL")
      {:error, :host_not_found}
    else
      RequestHostDeregistration.new!(
        %{host_id: host_id, deregistered_at: dat}
      )|> commanded().dispatch()
    end

    # case health do
    #   :critical -> :ok
    #   :passing -> {:error, :host_alive}
    #   _ -> {:error, :host_not_found}
    # end
  end

  defp commanded,
  do: Application.fetch_env!(:trento, Trento.Commanded)[:adapter]
end
