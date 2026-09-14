// Bake autoprefixer's output into Bootstrap's .scss sources.
//
// Bootstrap's own build runs autoprefixer *after* Sass. The `sass` R package
// (libsass) has no such step, so the prefixes have to be in the .scss we
// vendor, or the compiled stylesheet is missing what the official dist ships
// (-webkit-user-select, -webkit-mask-*, -webkit-print-color-adjust, ...).
//
// Usage: node vendor-bootstrap.mjs <src scss dir> <dest scss dir>
// Reads browserslist targets from .browserslistrc in the working directory.
import { readdir, readFile, writeFile, mkdir } from 'node:fs/promises'
import { join, dirname, relative } from 'node:path'
import postcss from 'postcss'
import scss from 'postcss-scss'
import autoprefixer from 'autoprefixer'

const [src, dest] = process.argv.slice(2)
const processor = postcss([autoprefixer])

async function scssFiles(dir) {
  const found = []
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name)
    if (entry.isDirectory()) found.push(...(await scssFiles(path)))
    else if (entry.name.endsWith('.scss')) found.push(path)
  }
  return found
}

for (const file of await scssFiles(src)) {
  const to = join(dest, relative(src, file))
  const result = await processor.process(await readFile(file, 'utf8'), {
    from: file,
    to,
    syntax: scss
  })
  await mkdir(dirname(to), { recursive: true })
  await writeFile(to, result.css)
}
