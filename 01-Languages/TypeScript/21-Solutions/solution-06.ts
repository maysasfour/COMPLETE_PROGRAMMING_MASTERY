// solution-06.ts - Record<Role, Permission[]> access-control matrix (Exercise 06)

type Role = "admin" | "editor" | "viewer";
type Permission = "read" | "write" | "delete";

// Record<Role, Permission[]> forces every Role to have an entry -- omitting "viewer" here
// would be a compile error, not a silent `undefined` discovered later at runtime.
const rolePermissions: Record<Role, Permission[]> = {
  admin: ["read", "write", "delete"],
  editor: ["read", "write"],
  viewer: ["read"],
};

function hasPermission(role: Role, permission: Permission): boolean {
  return rolePermissions[role].includes(permission);
}

function assertPermission(role: Role, permission: Permission): void {
  if (!hasPermission(role, permission)) {
    throw new Error(`Role "${role}" does not have permission "${permission}"`);
  }
}

const roles: Role[] = ["admin", "editor", "viewer"];
const permissions: Permission[] = ["read", "write", "delete"];

console.log("--- permission grid ---");
for (const role of roles) {
  for (const permission of permissions) {
    console.log(`${role} / ${permission}: ${hasPermission(role, permission)}`);
  }
}

console.log("\n--- assertPermission ---");
try {
  assertPermission("viewer", "delete");
} catch (e) {
  if (e instanceof Error) {
    console.log("expected error caught:", e.message);
  } else {
    throw e;
  }
}
