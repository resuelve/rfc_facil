defmodule VerificationDigitTest do
  use ExUnit.Case

  test "calculate/1" do
    assert VerificationDigit.calculate("GODE561231GR") == "8"
    assert VerificationDigit.calculate("AECS211112JP") == "A"
    assert VerificationDigit.calculate("OOGE52071115") == "1"
  end
end
