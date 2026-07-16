// solution-01.js - FizzBuzz with a for loop, and category counting with switch.

function fizzBuzzRange(start, end) {
  const results = [];
  for (let n = start; n <= end; n++) {
    if (n % 3 === 0 && n % 5 === 0) {
      results.push("FizzBuzz");
    } else if (n % 3 === 0) {
      results.push("Fizz");
    } else if (n % 5 === 0) {
      results.push("Buzz");
    } else {
      results.push(String(n));
    }
  }
  return results;
}

function countCategory(results, category) {
  let count = 0;
  for (const entry of results) {
    switch (category) {
      case "Fizz":
        if (entry === "Fizz") count++;
        break;
      case "Buzz":
        if (entry === "Buzz") count++;
        break;
      case "FizzBuzz":
        if (entry === "FizzBuzz") count++;
        break;
      default: // "Number"
        if (!Number.isNaN(Number(entry)) && entry !== "") count++;
        break;
    }
  }
  return count;
}

const results = fizzBuzzRange(1, 15);
console.log(results);
console.log(countCategory(results, "Fizz"));
console.log("Buzz count:", countCategory(results, "Buzz"));
console.log("FizzBuzz count:", countCategory(results, "FizzBuzz"));
console.log("Number count:", countCategory(results, "Number"));
