defmodule TenDigitsCodeTest do
  use ExUnit.Case

  test "should naturalPersonTenDigitsCode tdc for simple test-case" do
    assert TenDigitsCode.calculate("Juan", "Barrios", "Fernandez", ~D[1970-12-13]) == "BAFJ701213"
  end

  test "should naturalPersonTenDigitsCode tdc for one digit month/day" do
    assert TenDigitsCode.calculate("Juan", "Barrios", "Fernandez", ~D[1970-02-01]) == "BAFJ700201"
  end

  test "should naturalPersonTenDigitsCode tdc for date after year 2000" do
    assert TenDigitsCode.calculate("Juan", "Barrios", "Fernandez", ~D[2001-12-01]) == "BAFJ011201"
  end

  test "should exclude special particles in both last-names" do
    # DE, LA, LAS, MC, VON, DEL, LOS, Y, MAC, VAN, MI
    assert TenDigitsCode.calculate("Eric", "Mc Gregor", "Von Juarez", ~D[1970-12-13]) == "GEJE701213"
  end

  test "should exclude special particles in first last-name" do
    assert TenDigitsCode.calculate("Josue", "de la Torre", "Zarzosa", ~D[1970-12-13]) == "TOZJ701213"
  end

  test "should exclude special particles in second last-name" do
    assert TenDigitsCode.calculate("Josue", "Zarzosa", "de la Torre", ~D[1970-12-13]) == "ZATJ701213"
  end

  test "should use first word of compound first last name" do
    assert TenDigitsCode.calculate("Antonio", "Ponce de León", "Juarez", ~D[1970-12-13]) == "POJA701213"
  end

  test "should use first two letters of name if first last-name has just one letter" do
    assert TenDigitsCode.calculate("Alvaro", "de la O", "Lozano", ~D[1970-12-13]) == "OLAL701213"
  end

  test "should use first two letters of name if first last-name has just two letters" do
    assert TenDigitsCode.calculate("Ernesto", "Ek", "Rivera", ~D[1970-12-13]) == "ERER701213"
  end

  test "should use first name if person has multiple names" do
    assert TenDigitsCode.calculate("Luz María", "Fernández", "Juárez", ~D[1970-12-13]) == "FEJL701213"
  end

  test "should use second name if person has multiple names and first name is Jose" do
    assert TenDigitsCode.calculate("José Antonio", "Camargo", "Hernández", ~D[1970-12-13]) == "CAHA701213"
  end

  test "should use second name if person has multiple names and first name is Maria" do
    assert TenDigitsCode.calculate("María Luisa", "Ramírez", "Sánchez", ~D[1970-12-13]) == "RASL701213"
  end

  test "should use second name if person has multiple names and first name is Maria (Ma)" do
    assert TenDigitsCode.calculate("Ma Luisa", "Ramírez", "Sánchez", ~D[1970-12-13]) == "RASL701213"
  end

  test "should use second name if person has multiple names and first name is Maria (Ma.)" do
    assert TenDigitsCode.calculate("Ma. Luisa", "Ramírez", "Sánchez", ~D[1970-12-13]) == "RASL701213"
  end

  test "should use first 2 letters of second last-name if first last-name is: empty" do
    assert TenDigitsCode.calculate("Juan", "", "Martínez", ~D[1970-12-13]) == "MAJU701213"
  end

  test "should use first 2 letters of second last-name if first last-name is: nil" do
    assert TenDigitsCode.calculate("Juan", nil, "Martínez", ~D[1970-12-13]) == "MAJU701213"
  end

  test "should use first 2 letters of first last-name if second last-name is: empty" do
    assert TenDigitsCode.calculate("Gerarda", "Zafra", "", ~D[1970-12-13]) == "ZAGE701213"
  end

  test "should use first 2 letters of first last-name if second last-name is: nil" do
    assert TenDigitsCode.calculate("Gerarda", "Zafra", nil, ~D[1970-12-13]) == "ZAGE701213"
  end

  test "should replace final letter with X if name-code makes a forbidden word (BUEI -> BUEX)" do
    assert TenDigitsCode.calculate("Ingrid", "Bueno", "Ezquerra", ~D[1970-12-13]) == "BUEX701213"
  end

  test "should replace final letter with X if name-code makes a forbidden word (BUEY -> BUEX)" do
    assert TenDigitsCode.calculate("Yngrid", "Bueno", "Ezquerra", ~D[1970-12-13]) == "BUEX701213"
  end

  test "should use ma when first name starts with ma but is not maria" do
    assert TenDigitsCode.calculate("Marco Antonio", "Cano", "Barraza", ~D[1970-12-13]) == "CABM701213"
  end
end
