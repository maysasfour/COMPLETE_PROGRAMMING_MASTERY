// A vanilla-JS implementation of Material Design's ripple interaction --
// no component library, to make the underlying mechanism concrete: on click,
// create a real <span>, size and position it so its center is exactly the
// click point, let the CSS animation (md-ripple-effect) play, then remove it
// once finished so repeated clicks don't accumulate stale ripple elements.
function attachRipple(button) {
  button.addEventListener("click", (event) => {
    const rect = button.getBoundingClientRect();
    const diameter = Math.max(rect.width, rect.height);
    const radius = diameter / 2;

    const ripple = document.createElement("span");
    ripple.className = "md-ripple";
    ripple.style.width = ripple.style.height = `${diameter}px`;
    ripple.style.left = `${event.clientX - rect.left - radius}px`;
    ripple.style.top = `${event.clientY - rect.top - radius}px`;

    button.appendChild(ripple);
    ripple.addEventListener("animationend", () => ripple.remove());
  });
}

document.querySelectorAll(".md-button").forEach(attachRipple);
