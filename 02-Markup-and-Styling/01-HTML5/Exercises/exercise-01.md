# Exercise 01 — Build a Semantic Recipe Page

[Back to lesson](../README.md)

## Task

Create a standalone HTML5 file, `recipe.html`, for a recipe page. It must include:

1. Correct boilerplate: `<!DOCTYPE html>`, `lang`, `charset`, viewport meta tag, and a `<title>`.
2. A `<header>` containing the recipe's name as an `<h1>` and a short description.
3. A `<main>` containing:
   - An `<article>` for the recipe itself.
   - A `<section>` listing ingredients as an unordered list (`<ul>`).
   - A `<section>` listing steps as an ordered list (`<ol>`), since step order matters.
   - A `<figure>` with an `<img>` (any placeholder URL is fine) that has meaningful `alt` text and a `<figcaption>`.
4. A `<footer>` with a copyright line.

## Constraints

- No CSS or JavaScript required — this exercise is about structure and semantics only.
- Every image must have `alt` text describing what it shows, not its filename.
- Use `<ol>`, not `<ul>`, for the steps — order is meaningful there.

## Starter Code

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><!-- fill in --></title>
</head>
<body>
  <!-- build the rest here -->
</body>
</html>
```

## Expected Output

Opening `recipe.html` in a browser shows an unstyled but well-structured page: a title and description at the top, an ingredients list, a numbered steps list, an image with a caption, and a footer. Viewing page source should show correct, valid nesting with no `<div>` standing in for a semantic element that has a better fit.

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.html](../Solutions/solution-01.html).
