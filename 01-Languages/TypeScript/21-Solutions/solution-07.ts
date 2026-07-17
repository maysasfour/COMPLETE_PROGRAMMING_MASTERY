// solution-07.ts - generically-typed publish/subscribe event bus (Exercise 07)

// This MUST be a `type` alias, not an `interface`. An `interface` is "open" -- another
// file could `declare module`-merge more properties onto it later -- so the compiler
// refuses to treat it as satisfying an index-signature-shaped constraint like
// `Record<string, unknown>`, even though its properties structurally match. A `type`
// alias for an object literal is "closed" and satisfies the constraint directly. This is
// a real `tsc` error (TS2344), not a hypothetical -- discovered while verifying this
// exercise, see 21-Solutions' notes for the exact message.
type AppEvents = {
  userCreated: { id: number; name: string };
  userDeleted: { id: number };
};

// `Events extends Record<string, unknown>` constrains the bus to "any interface mapping
// event names to payload shapes," while `K extends keyof Events` on each method is what
// links a specific event name to its specific payload type at every call site -- a listener
// registered for "userCreated" gets a payload typed exactly `{ id: number; name: string }`,
// never a union across all events.
class TypedEventBus<Events extends Record<string, unknown>> {
  private listeners: { [K in keyof Events]?: Array<(payload: Events[K]) => void> } = {};

  on<K extends keyof Events>(event: K, listener: (payload: Events[K]) => void): void {
    const existing = this.listeners[event] ?? [];
    existing.push(listener);
    this.listeners[event] = existing;
  }

  emit<K extends keyof Events>(event: K, payload: Events[K]): void {
    for (const listener of this.listeners[event] ?? []) {
      listener(payload);
    }
  }
}

const bus = new TypedEventBus<AppEvents>();

const createdLog: string[] = [];
bus.on("userCreated", (payload) => {
  // payload is genuinely { id: number; name: string } here, not a union with userDeleted's shape
  console.log(`[listener A] user created: #${payload.id} ${payload.name}`);
});
bus.on("userCreated", (payload) => {
  createdLog.push(payload.name);
});
bus.on("userDeleted", (payload) => {
  console.log(`[listener] user deleted: #${payload.id}`);
});

bus.emit("userCreated", { id: 1, name: "Ada" });
bus.emit("userDeleted", { id: 2 });

console.log("createdLog after emit:", createdLog);
