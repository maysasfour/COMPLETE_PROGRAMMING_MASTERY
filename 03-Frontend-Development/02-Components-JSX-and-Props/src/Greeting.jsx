// The simplest possible component: a function that returns JSX. Props arrive as
// a single object argument -- destructuring it in the parameter list is the
// idiomatic way to both extract the values you need and document what the
// component expects, all in one line.
export function Greeting({ name, timeOfDay = 'day' }) {
  return (
    <p>
      Good {timeOfDay}, <strong>{name}</strong>!
    </p>
  )
}
