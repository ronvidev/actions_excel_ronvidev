import sys
import json
import traceback
import win32com.client as win32


class ImageToExcel:
    def __init__(self, template_xlsx, archivo_json, save_path) -> None:
        with open(archivo_json, "r", encoding="utf-8") as file:
            self.data = json.load(file)
        self.save_path = save_path
        self.sheets = self.data["sheets"]

        self.excel = win32.gencache.EnsureDispatch("Excel.Application")
        self.excel.Visible = False
        self.wb = self.excel.Workbooks.Open(template_xlsx)

    def obtener_columna_fila(self, celda):
        columna = "".join(letra for letra in celda if letra.isalpha())
        fila = "".join(digito for digito in celda if digito.isdigit())
        return (columna, int(fila))

    def put_image(self, foto_path, px, py, width, height):
        self.ws.Shapes.AddPicture(
            foto_path,
            False,
            True,
            px,
            py,
            width,
            height,
        )

    def process(self):
        for sheet in self.sheets:
            self.ws = self.wb.Sheets(sheet["nameSheet"])
            
            # Colocar textos
            for text in sheet["textSlots"]:
                cell = text["cell"]
                value = text["value"]
                self.ws.Range(cell).Value = value
            
            # Colocar imágenes
            for image in sheet["imageSlots"]:
                photos = image["photos"]
                cells = image["cells"]
                range_slot = self.ws.Range(cells)
                
                # Eliminar contenido de las celdas si hay fotos
                if len(photos) > 0:
                    range_slot.ClearContents()
                    
                px = range_slot.Left
                py = range_slot.Top
                width_range = range_slot.Width
                height_range = range_slot.Height

                if len(photos) == 1:
                    self.put_image(photos[0], px, py, width_range, height_range)

                elif len(photos) == 2:
                    width = width_range * (1 / 2)
                    height = height_range * (3 / 4)

                    for photo in photos:
                        self.put_image(photo, px, py, width, height)

                        px = px + width
                        py = py + height_range - height

                elif 3 <= len(photos) <= 4:
                    width = width_range * (1 / 2)
                    height = height_range * (1 / 2)

                    for photo in photos:
                        self.put_image(photo, px, py, width, height)

                        px = px + width

                        if px >= range_slot.Left + width_range:
                            px = range_slot.Left
                            py = py + height_range - height

        self.wb.SaveAs(self.save_path)
        self.wb.Close()
        # self.excel.Quit()


if __name__ == "__main__":
    archivo_json = sys.argv[1]
    template_path = sys.argv[2]
    save_path = sys.argv[3]

    try:
        imageToExcel = ImageToExcel(template_path, archivo_json, save_path)
        imageToExcel.process()
    except:
        print(traceback.format_exc())
