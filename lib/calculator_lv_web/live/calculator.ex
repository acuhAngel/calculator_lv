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
        disp: 0,
        last: nil,
        oper: nil
      )
    }
  end

  # ***** Renderizado de la pagina html *****
  def render(assigns), do: PageView.render("calculator.html", assigns)

  # ***** funciones de la calculadora  ****
  # ***** Concatena los numeros ingresados ****
  def select({numero, _}, n, socket) when is_float(numero) do
    d = socket.assigns.disp

    %{
      last: socket.assigns.last,
      disp: "#{d}#{n}",
      oper: socket.assigns.oper
    }
  end

  # ***** reinicia la memoria
  def select(_, n, _) when n == "reset" do
    %{
      disp: 0,
      last: nil,
      oper: nil
    }
  end

  # ***** borrar actual
  def select(_, n, socket) when n == "del" do
    %{
      last: socket.assigns.last,
      disp: 0,
      oper: socket.assigns.oper
    }
  end

  # ***** al presionar igual realiza la operacion segun el operador previamente ingresado
  def select(:error, n, socket) when n == "eq" do
    {l_n, _} = socket.assigns.last |> IO.inspect() |> Float.parse()
    {curr, _} = socket.assigns.disp |> Float.parse()
    oper = socket.assigns.oper |> IO.inspect()

    case oper do
      "+" ->
        %{
          last: l_n + curr,
          disp: "#{l_n + curr}",
          oper: nil
        }

      "-" ->
        %{
          last: l_n - curr,
          disp: "#{l_n - curr}",
          oper: nil
        }

      "/" ->
        %{
          last: l_n / curr,
          disp: "#{l_n / curr}",
          oper: nil
        }

      "x" ->
        %{
          last: l_n * curr,
          disp: "#{l_n * curr}",
          oper: nil
        }

      _ ->
        %{
          last: "",
          disp: socket.assigns.display,
          oper: nil
        }
    end
  end

  # ***** define el tipo de operacion
  def select(:error, n, socket) do
    %{
      last: socket.assigns.disp,
      disp: 0,
      oper: n
    }
  end

  def handle_event("calc", %{"number" => n}, socket) do
    IO.inspect(n)
    numero = Float.parse(n)
    x = select(numero, n, socket)
    CalculatorLvWeb.Endpoint.broadcast_from(self(), @topic, "edit_screen", %{disp: x.disp})

    {
      :noreply,
      assign(
        socket,
        last: x.last,
        disp: x.disp,
        oper: x.oper
      )
    }
  end

  def handle_info(%{topic: @topic, payload: payload}, socket) do
    {:noreply, assign(socket, :disp, payload.disp)}
  end
end
