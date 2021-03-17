defmodule PhxProject.Utils.RedisHelper do
  @ttl 60 * 60

  def set(%{id: id} = struct, ttl \\ @ttl) do
    Exredis.Api.set(id, Poison.encode!(struct))
    Exredis.Api.expire(id, ttl)
    struct
  end

  def get(id, type, ttl \\ @ttl) do
    case Exredis.Api.get(id) do
      :undefined ->
        :undefined
      value ->
        struct = Poison.decode!(value, as: type)
        Exredis.Api.expire(id, ttl)
        struct
    end
  end

  def delete(id), do: Exredis.Api.del(id)
end
