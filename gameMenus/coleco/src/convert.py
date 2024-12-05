def generar_rom_vhd(archivo_binario, archivo_vhd):
    with open(archivo_binario, 'rb') as f:
        datos = f.read()

    if len(datos) != 24 * 1024:
        raise ValueError("El archivo binario debe tener exactamente 24 KB.")

    # Dividir los datos en bloques de 8 bits
    bloques = [f"x\"{byte:02X}\"" for byte in datos]
    
    # Crear líneas de 8 valores cada una
    lineas = [", ".join(bloques[i:i+8]) for i in range(0, len(bloques), 8)]
    
    # Agregar comentarios con las direcciones
    lineas_comentadas = [
        f"      {linea}, -- 0x{i*8:04X}" for i, linea in enumerate(lineas)
    ]

    # Crear el archivo VHD
    with open(archivo_vhd, 'w') as f:
        f.write(
            """-- Internal ROM BIOS
--
-- Set up as a RAM to allow an alternate BIOS to be loaded from
-- and external location, or changed via code.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rombios is
   port (
      clock_i        : in  std_logic;
      we_i           : in  std_logic;
      addr_i         : in  std_logic_vector(12 downto 0);
      data_i         : in  std_logic_vector(7 downto 0);
      data_o         : out std_logic_vector(7 downto 0)
   );
end;

architecture rtl of rombios is

   type ram_t is array(0 to 8191) of std_logic_vector(7 downto 0);
   signal ram_q : ram_t := (
"""
        )
        f.write(",\n".join(lineas_comentadas))
        f.write(
            """
   );

begin
   process(clock_i)
   begin
      if rising_edge(clock_i) then
         if we_i = '1' then
            ram_q(to_integer(unsigned(addr_i))) <= data_i;
         end if;
         data_o <= ram_q(to_integer(unsigned(addr_i)));
      end if;
   end process;

end rtl;
"""
        )

# Ejemplo de uso
archivo_bin = "phoenixBoot.rom"     # Cambia por la ruta de tu archivo binario
archivo_vhd = "romloader.vhd"     # Cambia por la ruta de salida deseada
generar_rom_vhd(archivo_bin, archivo_vhd)
