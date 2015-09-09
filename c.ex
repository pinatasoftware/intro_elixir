defmodule C do

  def map([], _func), do: []
  def map([head|tail], func), do: [func.(head)|map(tail, func)]

  def pmap(collection, func) do
    collection |> spawn_children(func) |> collect_results
  end

  def spawn_children(collection, func) do
    map collection, fn element -> spawn(__MODULE__, :child, [element, func, self]) end
  end

  def child(element, func, parent) do
    send parent, {self, func.(element)}
  end

  def collect_results(pids) do
    map pids, fn pid -> receive do: ( { ^pid, value } -> value) end
  end
end


IO.inspect C.pmap [1,2,3,4,5,6], fn x -> x*x end
