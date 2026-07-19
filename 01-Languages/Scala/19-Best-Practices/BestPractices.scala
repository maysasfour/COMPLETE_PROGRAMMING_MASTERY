// 19 - Best Practices
// Immutability-first design, avoiding null (Option instead), and a real anti-pattern/fix pair.

// --- ANTI-PATTERN: a mutable, null-permitting "bag of state" class ---
class UserAccountUnsafe(var name: String, var email: String):
  private var lastLoginNote: String = null // null used as "no note yet" -- a landmine
  def setLastLoginNote(note: String): Unit = lastLoginNote = note
  def describeLastLogin(): String =
    // caller must remember lastLoginNote might be null -- nothing in the type says so
    lastLoginNote.toUpperCase // CRASHES with NullPointerException if never set

// --- FIX: immutable data + Option instead of null ---
final case class UserAccountSafe(name: String, email: String, lastLoginNote: Option[String] = None):
  // returning a new instance rather than mutating -- immutability by construction
  def withLoginNote(note: String): UserAccountSafe = copy(lastLoginNote = Some(note))
  def describeLastLogin(): String =
    lastLoginNote.map(_.toUpperCase).getOrElse("(no login note recorded)") // no crash possible

@main def bestPracticesDemo(): Unit =
  println("--- anti-pattern: mutable state + null, demonstrated crashing for real ---")
  val unsafe = UserAccountUnsafe("Ada", "ada@example.com")
  try
    println(unsafe.describeLastLogin()) // never called setLastLoginNote -- null.toUpperCase
  catch
    case e: NullPointerException =>
      println(s"CRASHED as predicted: ${e.getClass.getSimpleName}")

  println("\n--- fix: immutable case class + Option, no crash possible ---")
  val safe = UserAccountSafe("Ada", "ada@example.com")
  println(safe.describeLastLogin()) // Option handles "not set" safely, no null anywhere

  val safeAfterLogin = safe.withLoginNote("logged in from new device")
  println(safeAfterLogin.describeLastLogin())
  println(s"original 'safe' is UNCHANGED (immutability): ${safe.describeLastLogin()}")

  println("\n--- immutability-first: val over var, and immutable collections ---")
  val fixedList = List(1, 2, 3)          // immutable by default -- no accidental external mutation
  val recomputed = fixedList.appended(4)  // returns a NEW list; fixedList itself never changes
  println(s"fixedList  = $fixedList (unchanged)")
  println(s"recomputed = $recomputed")
