import sys
import json
import traceback
import win32com.client as win32


class ImageToExcel:
    def __init__(self, archivo_excel, archivo_json, save_path) -> None:
        with open(archivo_json, "r", encoding="utf-8") as file:
            self.data = json.load(file)
        self.save_path = save_path
        self.sheets = self.data["sheets"]

        self.excel = win32.gencache.EnsureDispatch("Excel.Application")
        self.excel.Visible = False
        self.wb = self.excel.Workbooks.Open(archivo_excel)

    def obtener_columna_fila(self, celda):
        columna = "".join(letra for letra in celda if letra.isalpha())
        fila = "".join(digito for digito in celda if digito.isdigit())
        return (columna, int(fila))

    def put_image(self, foto_path, coords):
        rango = self.ws.Range(coords)
        rango.ClearContents()
        self.ws.Shapes.AddPicture(
            foto_path,
            False,
            True,
            rango.Left,
            rango.Top,
            rango.Width,
            rango.Height,
        )

    def process(self):
        for sheet in self.sheets:
            self.ws = self.wb.Sheets(sheet["nameSheet"])

            for image in sheet["slots"]:
                photos = image["photos"]
                cells = image["cells"]
                cell_init, cell_end = cells.split(":")

                col_init, row_init = self.obtener_columna_fila(cell_init)
                col_end, row_end = self.obtener_columna_fila(cell_end)
                cols = ord(col_end) - ord(col_init) + 1
                rows = row_end - row_init + 1

                if len(photos) == 1:
                    self.put_image(photos[0], cells)

                elif len(photos) == 2:
                    for photo in photos:
                        col_init, row_init = self.obtener_columna_fila(cell_init)

                        cell_end = (
                            f"{chr(ord(col_init) + cols - 3)}{row_init + rows - 2}"
                        )
                        cells = f"{cell_init}:{cell_end}"

                        self.put_image(photo, cells)

                        cell_init = f"{chr(ord(col_init) + 2)}{row_init + 1}"

                elif len(photos) == 3:
                    for i, photo in enumerate(photos):
                        col_init, row_init = self.obtener_columna_fila(cell_init)

                        cell_end = (
                            f"{chr(ord(col_init) + cols - 3)}{row_init + rows - 3}"
                        )
                        cells = f"{cell_init}:{cell_end}"

                        self.put_image(photo, cells)

                        if i == 0:
                            cell_init = f"{chr(ord(col_init) + 2)}{row_init}"
                        else:
                            cell_init = f"{chr(ord(col_init) - 2)}{row_init + 2}"

        self.wb.SaveAs(self.save_path)
        self.wb.Close()
        # self.excel.Quit()


if __name__ == "__main__":
    archivo_json = sys.argv[1]
    archivo_excel = sys.argv[2]
    save_path = sys.argv[3]
    
    try:
        imageToExcel = ImageToExcel(archivo_excel, archivo_json, save_path)
        imageToExcel.process()
    except:
        print(traceback.format_exc())
