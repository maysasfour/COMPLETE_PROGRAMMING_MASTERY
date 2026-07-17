// CSS Modules, processed for real via postcss + postcss-modules -- proving
// (not just describing) that two DIFFERENT files' identically-named ".title"
// classes are rewritten to two DIFFERENT, non-colliding generated names.
import postcss from 'postcss';
import postcssModules from 'postcss-modules';
import { readFileSync, writeFileSync } from 'node:fs';

async function processModule(inputPath, outputCssPath) {
  const source = readFileSync(inputPath, 'utf-8');
  let exportedNames;

  const result = await postcss([
    postcssModules({
      getJSON(_cssFileName, json) {
        exportedNames = json;
      },
    }),
  ]).process(source, { from: inputPath, to: outputCssPath });

  writeFileSync(outputCssPath, result.css);
  return exportedNames;
}

const alertNames = await processModule('alert.module.css', 'alert.generated.css');
const cardNames = await processModule('card.module.css', 'card.generated.css');

console.log('=== alert.module.css exported class name mapping ===');
console.log(alertNames);

console.log('\n=== card.module.css exported class name mapping ===');
console.log(cardNames);

console.log('\n=== The core proof: both files define a ".title" class -- do the GENERATED names collide? ===');
console.log('alert.module.css .title  ->', alertNames.title);
console.log('card.module.css  .title  ->', cardNames.title);
console.log('Generated names are different (no collision):', alertNames.title !== cardNames.title);

// Write a real demo.html using the ACTUAL generated names (never hardcoded --
// they're content-hashed and change whenever the source .module.css changes),
// so this demo can never silently go stale relative to the real build output.
const demoHtml = `<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>CSS Modules</title>
<link rel="stylesheet" href="alert.generated.css">
<link rel="stylesheet" href="card.generated.css">
</head>
<body>
  <div class="${alertNames.alert} ${alertNames.success}">
    <p class="${alertNames.title}">Success (alert's .title)</p>
    <p>Your changes were saved.</p>
  </div>
  <div class="${cardNames.card}" style="margin-top: 16px;">
    <p class="${cardNames.title}">A Card (card's OWN, differently-scoped .title)</p>
  </div>
</body>
</html>
`;
writeFileSync('demo.html', demoHtml);
console.log('\nWrote demo.html using the real generated class names above.');
