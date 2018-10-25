# WGS data preparation

Pipeline to clean, align, and prepare sequence data for WGS analyses

## WARNING

These scripts work only for members of the Bernatchez lab on the katak and
manitou servers. They will require modifications and software installation to
work under other circumstances.

## Attribution

- Scripts 03 to 08 are based on scripts by Clément Rougeux
- Script 09 is based on a script by Nina Overgaard Therkildsen

## Usage

Run each script in `01_scripts` individually or adjust the SLURM job values
in `runall.sh` and launch:

```bash
./runall.sh
```

## Licence

MIT License

Copyright (c) 2018 Eric Normandeau

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
