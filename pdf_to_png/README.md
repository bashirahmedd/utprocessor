# PNG to JPEG Conversion Script

This folder includes `main_png_jpeg.sh`, a small Bash script that converts PNG files in a directory into JPEG files.

## Requirements

- Bash
- ImageMagick, with the `convert` command available

Check ImageMagick with:

```bash
convert -version
```

## Usage

From this folder, run:

```bash
./main_png_jpeg.sh /path/to/png-directory
```

Example:

```bash
./main_png_jpeg.sh ./output_pages
```

If no directory is provided, the script uses the current directory:

```bash
./main_png_jpeg.sh
```

## What It Does

For each `.png` file in the selected directory, the script creates a `.jpg` file with the same base name.

Example:

```text
page-1.png -> page-1.jpg
page-2.png -> page-2.jpg
```

The JPEG files are written into the same directory as the PNG files.

## Notes

- The script processes files ending in `.png`.
- It does not search subdirectories recursively.
- Existing `.jpg` files with the same names will be overwritten.
- Transparent PNG backgrounds are flattened onto white before saving as JPEG.

## Make the Script Executable

If needed, make the script executable first:

```bash
chmod +x main_png_jpeg.sh
```

## Remove PNG Manually

After confirming the JPEG files were created successfully, you can manually remove the original PNG files.

1. Go to the folder that contains the PNG files:

```bash
cd /path/to/png-directory
```

2. Optional: list the PNG files before deleting them:

```bash
ls ./*.png
```

3. Remove the PNG files:

```bash
rm ./*.png
```

This deletes only `.png` files in the current folder. It does not remove PNG files from subdirectories.
