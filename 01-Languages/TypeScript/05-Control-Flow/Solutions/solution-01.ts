// solution-01.ts - discriminated PaymentMethod union with an exhaustive switch.

interface CreditCard {
  kind: "credit_card";
  last4: string;
}
interface PayPal {
  kind: "paypal";
  email: string;
}
interface BankTransfer {
  kind: "bank_transfer";
  iban: string;
}
type PaymentMethod = CreditCard | PayPal | BankTransfer;

function describePayment(method: PaymentMethod): string {
  switch (method.kind) {
    case "credit_card":
      return `Credit card ending in ${method.last4}`;
    case "paypal":
      return `PayPal account: ${method.email}`;
    case "bank_transfer":
      return `Bank transfer to ${method.iban}`;
    default: {
      const _exhaustive: never = method;
      return _exhaustive;
    }
  }
}

console.log(describePayment({ kind: "credit_card", last4: "1234" }));
console.log(describePayment({ kind: "paypal", email: "ada@example.com" }));
console.log(describePayment({ kind: "bank_transfer", iban: "DE00 1234 5678" }));
