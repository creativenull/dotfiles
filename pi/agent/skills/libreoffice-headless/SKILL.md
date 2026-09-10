---
name: libreoffice-headless
description: Use LibreOffice (soffice) in headless mode from the command line to convert documents between formats (PDF, DOCX, ODT, CSV, HTML, EPUB), extract text, and print to file — without a GUI. Use whenever a task involves converting or batch-processing office documents.
---

# LibreOffice Headless Mode

Binary: `soffice`. Resolve with `command -v soffice || command -v libreoffice` first; fallback paths:
- Linux: `/usr/bin/soffice`, `/usr/bin/libreoffice`
- macOS: `/Applications/LibreOffice.app/Contents/MacOS/soffice`

## Parameter-passing rules (the important part)

1. **Always quote the `--convert-to` value in single quotes.** The value can contain spaces, commas, quotes, and JSON — quoting avoids shell mangling:
   ```bash
   --convert-to 'pdf:writer_pdf_Export'          # format only
   --convert-to 'docx:"MS Word 2007 XML"'        # format:"Filter Name" — filter names with spaces use escaped double quotes
   --convert-to 'pdf:writer_pdf_Export:{...}'    # format:filter:{options JSON}
   ```
2. **Filter options are a JSON string appended after the filter name with `:`**, each option shaped as `{"Name":{"type":"<string|long|boolean>","value":"..."}}`, multiple options comma-separated inside one object:
   ```bash
   --convert-to 'pdf:writer_pdf_Export:{"SelectPdfVersion":{"type":"long","value":"2"},"TiledWatermark":{"type":"string","value":"draft"}}'
   ```
   Boolean: `"true"`/`"false"` as strings. Long: decimal digits as strings (e.g. PDF version `0`=1.7 default, `2`=PDF/A-2b, `17`=1.7 explicit).
   **Not every option works on every build** — options can fail with an IO write error or silently. Verify the output file, and fall back to post-processing (e.g. `qpdf`/`pdftk` for page ranges) when an option misbehaves.
3. **`--outdir` before the input files.** Output filename = input name with new extension, written to `--outdir` (default: cwd). Batch by glob: `soffice --headless --convert-to pdf --outdir out/ *.docx`.
4. **Isolate the profile or conversions silently fail** when a GUI LibreOffice is running (a second soffice just forwards to the running instance) — always pass `-env:UserInstallation=file:///tmp/lo-headless-$$`. One profile per process for parallel runs.
5. **Verify output files, not exit codes** — `soffice` returns 0 even on failure:
   ```bash
   soffice --headless --norestore -env:UserInstallation=file:///tmp/lo-headless-$$ \
     --convert-to pdf --outdir out/ input.docx && test -s out/input.pdf
   ```

## Commands

### Convert
```bash
soffice --headless --norestore -env:UserInstallation=file:///tmp/lo-headless-$$ \
  --convert-to pdf --outdir out/ input.docx          # any office file -> PDF
soffice --headless --norestore -env:UserInstallation=file:///tmp/lo-headless-$$ \
  --convert-to docx:"MS Word 2007 XML" input.odt      # odt -> docx
soffice --headless --norestore -env:UserInstallation=file:///tmp/lo-headless-$$ \
  --convert-to epub input.doc                         # -> epub
```
Filter names: `pdf` / `pdf:calc_pdf_Export` / `pdf:impress_pdf_Export` / `pdf:draw_pdf_Export`, `docx:"MS Word 2007 XML"`, `xlsx:"Calc MS Excel 2007 XML"`, `pptx:"Impress MS PowerPoint 2007 XML"`, `odt`/`ods`/`odp`/`odg`, `rtf:Rich Text Format`, `html:"XHTML Writer File:UTF8"`, `epub:writer_epub_export`, `png:"impress_png_Export"` (etc. per component).

### CSV (options matter — separator,delimiter,charset,firstrow as ASCII codes: 44=comma, 59=semicolon, 9=tab, 34=quote, 76=UTF-8)
```bash
soffice --headless --norestore -env:UserInstallation=file:///tmp/lo-headless-$$ \
  --convert-to 'csv:"Text - txt - csv (StarCalc)":44,34,76,1' input.xlsx
```

### Extract text / scripts
```bash
soffice --headless --cat input.docx        # document text to stdout
soffice --headless --script-cat input.odt  # embedded scripts to stdout
```

### Print to file
```bash
soffice --headless --print-to-file --outdir out/ input.docx
```

### Run macros
```bash
soffice --headless input.odt macro:///Standard.Module1.MyMacro   # from My Macros
soffice --headless input.odt macro://./Standard.Module1.MyMacro  # embedded in file
```

### Force input format when opening (e.g. encoded text)
```bash
soffice --headless --infilter="Text (encoded):UTF8,LF,,," --convert-to pdf data.txt
```

Full switch reference: `soffice --help`. PDF option list: https://help.libreoffice.org/latest/en-US/text/shared/guide/pdf_params.html