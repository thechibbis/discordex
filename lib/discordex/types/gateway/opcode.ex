defmodule Discordex.Types.Gateway.Opcode do
  @moduledoc """
  Discord gateway opcodes.

  See: https://docs.discord.com/developers/topics/opcodes-and-status-codes#gateway-gateway-opcodes
  """

  @type t ::
          :dispatch
          | :heartbeat
          | :identify
          | :presence_update
          | :voice_state_update
          | :resume
          | :reconnect
          | :request_guild_members
          | :invalid_session
          | :hello
          | :heartbeat_ack

  @spec encode(t()) :: pos_integer()
  def encode(:dispatch), do: 0
  def encode(:heartbeat), do: 1
  def encode(:identify), do: 2
  def encode(:presence_update), do: 3
  def encode(:voice_state_update), do: 4
  def encode(:resume), do: 6
  def encode(:reconnect), do: 7
  def encode(:request_guild_members), do: 8
  def encode(:invalid_session), do: 9
  def encode(:hello), do: 10
  def encode(:heartbeat_ack), do: 11

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(0), do: {:ok, :dispatch}
  def decode(1), do: {:ok, :heartbeat}
  def decode(2), do: {:ok, :identify}
  def decode(3), do: {:ok, :presence_update}
  def decode(4), do: {:ok, :voice_state_update}
  def decode(6), do: {:ok, :resume}
  def decode(7), do: {:ok, :reconnect}
  def decode(8), do: {:ok, :request_guild_members}
  def decode(9), do: {:ok, :invalid_session}
  def decode(10), do: {:ok, :hello}
  def decode(11), do: {:ok, :heartbeat_ack}
  def decode(_), do: :error
end
