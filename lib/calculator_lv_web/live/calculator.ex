defmodule CalculatorLvWeb.Calculator do
  use Phoenix.LiveView
  alias CalculatorLvWeb.PageView

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        display: 0,
        last: nil,
        current: 0,
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
    %{
      display: 0,
      last: nil,
      current: 0,
      oper: nil
    }
  end


  def select(:error, n, socket) when n == "eq" do
    {l_n, _} = socket.assigns.last |> IO.inspect |> Float.parse
    {curr, _} = socket.assigns.display |> Float.parse
    oper = socket.assigns.oper |> IO.inspect
    case oper do
      "+" -> {
        :noreply,
        assign(
          socket,
          last: nil,
          display: l_n + curr,
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

    x = select(numero, n, socket)

    # if numero == :error do
    #   l_n = socket.assigns.display |> Float.parse

    #   {
    #     :noreply,
    #     assign(
    #       socket,
    #       last: l_n,
    #       display: n,
    #       oper: n
    #     )
    #   }
    # else
    #   # s = select(numero) |> IO.inspect
    #   l_n = socket.assigns.display
    #   {
    #     :noreply,
    #     assign(
    #       socket,
    #       display: "#{l_n}#{n}"

    #     )
    #   }
    # end

  end
end
