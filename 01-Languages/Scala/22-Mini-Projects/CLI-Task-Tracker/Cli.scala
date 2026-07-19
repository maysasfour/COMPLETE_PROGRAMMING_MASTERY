// The CLI entry point. Each invocation opens the SQLite file database, performs ONE
// command (from argv), then exits -- letting the demo below simulate a multi-session
// CLI tool by invoking the same jar/class repeatedly with different arguments while
// tasks.db on disk persists state between them, exactly like a real CLI tool would
// across separate terminal invocations.

import java.sql.DriverManager

object Cli:
  def run(args: Array[String], dbPath: String): Unit =
    Class.forName("org.sqlite.JDBC")
    val conn = DriverManager.getConnection(s"jdbc:sqlite:$dbPath")
    try
      val repo = TaskRepository(conn)
      repo.initSchema()

      args.toList match
        case "add" :: rest if rest.nonEmpty =>
          val description = rest.mkString(" ")
          val id = repo.add(description)
          println(s"added task #$id: $description")

        case "list" :: Nil =>
          val tasks = repo.list()
          if tasks.isEmpty then println("no tasks yet")
          else tasks.foreach { t =>
            val marker = if t.done then "[x]" else "[ ]"
            println(s"$marker #${t.id} ${t.description}")
          }

        case "complete" :: idStr :: Nil =>
          idStr.toIntOption match
            case Some(id) =>
              if repo.complete(id) then println(s"completed task #$id")
              else println(s"no task with id $id")
            case None => println(s"'$idStr' is not a valid task id")

        case "delete" :: idStr :: Nil =>
          idStr.toIntOption match
            case Some(id) =>
              if repo.delete(id) then println(s"deleted task #$id")
              else println(s"no task with id $id")
            case None => println(s"'$idStr' is not a valid task id")

        case other =>
          println(s"usage: add <description> | list | complete <id> | delete <id>")
          println(s"unrecognized: ${other.mkString(" ")}")
    finally conn.close()

@main def taskTrackerCli(args: String*): Unit =
  Cli.run(args.toArray, "tasks.db")
