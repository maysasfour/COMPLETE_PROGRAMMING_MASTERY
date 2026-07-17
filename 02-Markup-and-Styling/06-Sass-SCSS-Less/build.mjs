// Sass, SCSS, and Less -- compiled programmatically via their real JS APIs
// (not just the CLI), with assertions on the actual generated CSS.
import * as sass from 'sass';
import less from 'less';
import { readFileSync } from 'node:fs';

console.log('=== Compiling main.scss (modern @use module system) ===');
const scssResult = sass.compile('src/main.scss');
console.log(scssResult.css);

const scssChecks = {
  'variable $primary-color resolved to #4f46e5': scssResult.css.includes('#4f46e5'),
  'nesting flattened to real .card__title selector': scssResult.css.includes('.card__title'),
  'mixin expanded for BOTH the default and danger button (2x "border-radius: 4px")':
    (scssResult.css.match(/border-radius: 4px/g) || []).length === 2,
  '$spacing-unit * 2 arithmetic resolved to 16px': scssResult.css.includes('16px'),
};
for (const [check, passed] of Object.entries(scssChecks)) {
  console.log(`  [${passed ? 'PASS' : 'FAIL'}] ${check}`);
}

console.log('\n=== Compiling main.less (variables + nesting + mixin, same design as the SCSS above) ===');
const lessSource = readFileSync('src/main.less', 'utf-8');
const lessResult = await less.render(lessSource, { filename: 'src/main.less' });
console.log(lessResult.css);

const lessChecks = {
  'variable @primary-color resolved to #4f46e5': lessResult.css.includes('#4f46e5'),
  'nesting flattened to real .card__title selector': lessResult.css.includes('.card__title'),
  'mixin expanded for both buttons (2x "border-radius: 4px")':
    (lessResult.css.match(/border-radius: 4px/g) || []).length === 2,
};
for (const [check, passed] of Object.entries(lessChecks)) {
  console.log(`  [${passed ? 'PASS' : 'FAIL'}] ${check}`);
}

console.log('\n=== Sass and Less compile the SAME design to equivalent CSS (the point of a preprocessor) ===');
function normalize(css) {
  return css.replace(/\s+/g, ' ').trim();
}
console.log('SCSS and Less output normalize to the same CSS:', normalize(scssResult.css) === normalize(lessResult.css));

console.log('\n=== A real, genuine Dart Sass deprecation warning: @import (legacy) vs @use (modern) ===');
try {
  sass.compile('src/legacy-import-style.scss', { logger: sass.Logger.silent });
  console.log('(warnings suppressed via a silent logger for this script\'s own clean stdout -- '
    + 'the REAL warning text, captured verbatim via the sass CLI, is documented in this lesson\'s README)');
} catch (e) {
  console.log('Unexpected compile error:', e.message);
}
