defmodule CalculatorLvWeb.Calculator do
  use Phoenix.LiveView
  alias CalculatorLvWeb.PageView

  @topic "calc"

  def mount(_params, _session, socket) do
    # CalculatorLvWeb.Endpoint.subscribe(@topic)
    {
      :ok,
      assign(
        socket,
        display: 0,
        last: nil,
        oper: nil
      )
    }
  end

  #***** Renderizado de la pagina html *****
  def render(assigns), do: PageView.render("calculator.html", assigns)

  #***** funciones de la calculadora  ****
  #***** Concatena los numeros ingresados ****
  def select({numero,_}, n, socket) when is_float(numero) do
    d = socket.assigns.display |> IO.inspect

    {
      :noreply,
      assign(
        socket,
        last: socket.assigns.last,
        display: "#{d}#{n}",
        oper: socket.assigns.oper
      )
    }

  end

 #***** reinicia la memoria
  def select(_, n, socket) when n == "reset" do
    {
      :noreply,
      assign(
        socket,
        display: 0,
        last: nil,
        oper: nil
      )
    }
  end

#***** borrar actual
def select(_, n, socket) when n == "del" do
  {
    :noreply,
    assign(
      socket,
      last: socket.assigns.last,
      display: 0,
      oper: socket.assigns.oper
    )
  }
end

#***** al presionar igual realiza la operacion segun el operador previamente ingresado
  def select(:error, n, socket) when n == "eq" do
    {l_n, _} = socket.assigns.last |> IO.inspect |> Float.parse
    {curr, _} = socket.assigns.display |> Float.parse
    oper = socket.assigns.oper |> IO.inspect
    case oper do
      "+" -> {
        :noreply,
        assign(
          socket,
          last: l_n + curr,
          display: "#{l_n + curr}",
          oper: nil
        )
      }
      "-" -> {
        :noreply,
        assign(
          socket,
          last: l_n - curr,
          display: "#{l_n - curr}",
          oper: nil
        )
      }
      "/" -> {
        :noreply,
        assign(
          socket,
          last: l_n / curr,
          display: "#{l_n / curr}",
          oper: nil
        )
      }
      "x" -> {
        :noreply,
        assign(
          socket,
          last: l_n * curr,
          display: "#{l_n * curr}",
          oper: nil
        )
      }

    end

  end

#***** define el tipo de operacion
    def select(:error, n, socket) do

      {
        :noreply,
        assign(
          socket,
          last: socket.assigns.display,
          display: 0,
          oper: n
        )
      }
    end

  def handle_event("calc", %{"number" => n} = data, socket) do
    IO.inspect(n)
    numero = Float.parse(n)
    select(numero, n, socket)
  end

end
