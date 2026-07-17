# HTML5 and CSS3 Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../02-Markup-and-Styling/README.md)

## HTML5 Structure
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title</title>
</head>
<body>
    <header></header>
    <nav></nav>
    <main>
        <section></section>
        <article></article>
        <aside></aside>
    </main>
    <footer></footer>
</body>
</html>
```

## Forms
```html
<form action="/submit" method="POST">
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>
    <input type="submit" value="Send">
</form>
```

## CSS Selectors
```css
.class-name { }          /* class */
#id-name { }              /* id */
element { }                /* tag */
element.class { }          /* combined */
parent > child { }         /* direct child */
a:hover { }                 /* pseudo-class */
p::first-line { }           /* pseudo-element */
```

## Flexbox
```css
.container {
    display: flex;
    justify-content: center;   /* main-axis alignment */
    align-items: center;        /* cross-axis alignment */
    gap: 1rem;
    flex-direction: row;        /* or column */
}
.item { flex: 1; }              /* grow to fill available space */
```

## Grid
```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: auto 1fr auto;
    gap: 1rem;
}
```

## Box Model
```css
.box {
    width: 100px;
    padding: 10px;    /* inside the border */
    border: 1px solid black;
    margin: 10px;      /* outside the border */
    box-sizing: border-box; /* width includes padding+border, not added on top */
}
```

## Responsive Design
```css
@media (max-width: 768px) {
    .container { flex-direction: column; }
}
```

See the [full HTML5/CSS3 module](../../02-Markup-and-Styling/README.md) for verified, rendered lessons on everything above.
