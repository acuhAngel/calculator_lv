defmodule CalculatorLvWeb.Calculator do
  use Phoenix.LiveView
  alias CalculatorLvWeb.PageView

  @topic "calc"

  def mount(_params, _session, socket) do
    CalculatorLvWeb.Endpoint.subscribe(@topic)

    {
      :ok,
      assign(
        socket,
        display: "",
        oper: "",
        total: ""
      )
    }
  end

  # ***** Renderizado de la pagina html *****
  def render(assigns), do: PageView.render("calculator.html", assigns)

  def operation("", display, _) do
    IO.puts("primero")
    "#{display}"
  end

  def operation(last, "", _) do
    IO.puts("dar igual sin ingresar un segundo valor")
    last
  end

  def operation(last, display, oper) do
    # |> IO.inspect(label: "primer valor")
    {f, _} = last |> Float.parse()
    # oper |> IO.inspect()
    # |> IO.inspect(label: "segundo valor")
    {s, _} = display |> Float.parse()

    case oper do
      "+" -> f + s
      "-" -> f - s
      "/" -> f / s
      "x" -> f * s
    end
  end

  def handle_event("number", %{"number" => n}, socket) do
    display = socket.assigns.display <> n

    CalculatorLvWeb.Endpoint.broadcast_from(self(), @topic, "refresh", %{display: display})

    {
      :noreply,
      assign(
        socket,
        display: "#{display}"
      )
    }
  end

  def handle_event("calc", %{"operator" => oper}, socket) do
    last = socket.assigns.total |> IO.inspect(label: "valor 1")
    l_oper = socket.assigns.oper |> IO.inspect()
    display = socket.assigns.display |> IO.inspect(label: "valor 2")
    total = operation(last, display, l_oper) |> IO.inspect(label: "resultado")

    {
      :noreply,
      assign(
        socket,
        display: "",
        total: "#{total}",
        oper: oper
      )
    }
  end

  def handle_event("solve", _, socket) do
    last = socket.assigns.total |> IO.inspect(label: "valor 1")
    oper = socket.assigns.oper |> IO.inspect()
    display = socket.assigns.display |> IO.inspect(label: "valor 2")

    total = operation(last, display, oper) |> IO.inspect(label: "resultado")

    CalculatorLvWeb.Endpoint.broadcast_from(self(), @topic, "refresh", %{display: total})

    {
      :noreply,
      assign(
        socket,
        total: "",
        display: "#{total}",
        oper: ""
      )
    }
  end

  def handle_event("reset", _, socket) do
    CalculatorLvWeb.Endpoint.broadcast_from(self(), @topic, "refresh", %{})

    {
      :noreply,
      assign(
        socket,
        display: "",
        total: "",
        oper: ""
      )
    }
  end

  def handle_event("del", _, socket) do
    CalculatorLvWeb.Endpoint.broadcast_from(self(), @topic, "refresh", %{})

    {
      :noreply,
      assign(
        socket,
        display: ""
      )
    }
  end

  def handle_info(%{topic: @topic, payload: payload}, socket) do
    {:noreply, assign(socket, :display, payload.display)}
  end
end
