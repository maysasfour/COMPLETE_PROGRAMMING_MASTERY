<?php

declare(strict_types=1);

require_once __DIR__ . '/src/TaskItem.php';
require_once __DIR__ . '/src/TaskNotFoundException.php';
require_once __DIR__ . '/src/TaskRepository.php';

/**
 * A file-backed SQLite database (not :memory:) so data survives between
 * separate `php cli.php ...` invocations -- each run of this script is a
 * fresh PHP process with no state of its own, unlike a long-running server.
 */
function connect(): PDO
{
    $dbPath = __DIR__ . '/tasks.db';
    return new PDO('sqlite:' . $dbPath);
}

function printUsage(): void
{
    echo <<<USAGE
    Usage:
      php cli.php add <title> [--priority low|medium|high]
      php cli.php list [--status pending|done]
      php cli.php done <id>
      php cli.php delete <id>
      php cli.php stats

    USAGE;
}

/**
 * A hand-rolled flag parser instead of a third-party CLI library -- this
 * project is deliberately install-free (matching the rest of this course),
 * and the flag surface is small enough that a manual scan of $args is
 * clearer than pulling in a dependency for it.
 */
function extractFlag(array &$args, string $flag): ?string
{
    foreach ($args as $i => $arg) {
        if ($arg === $flag && isset($args[$i + 1])) {
            $value = $args[$i + 1];
            unset($args[$i], $args[$i + 1]);
            $args = array_values($args);
            return $value;
        }
    }
    return null;
}

function formatTask(TaskItem $task): string
{
    $mark = $task->status === Status::Done ? '[x]' : '[ ]';
    return sprintf(
        '%s #%-3d %-30s priority=%-6s created=%s',
        $mark,
        $task->id,
        $task->title,
        $task->priority->label(),
        $task->createdAt,
    );
}

function run(array $argv): int
{
    $args = array_slice($argv, 1);
    if ($args === []) {
        printUsage();
        return 0;
    }

    $command = array_shift($args);
    $repo = new TaskRepository(connect());

    try {
        switch ($command) {
            case 'add':
                $priorityFlag = extractFlag($args, '--priority');
                $title = implode(' ', $args);
                if ($title === '') {
                    echo "Error: a task title is required.\n";
                    return 1;
                }
                $priority = $priorityFlag !== null
                    ? Priority::from($priorityFlag)
                    : Priority::Medium;
                $task = $repo->add($title, $priority);
                echo "Added task #{$task->id}: {$task->title} (priority={$task->priority->label()})\n";
                return 0;

            case 'list':
                $statusFlag = extractFlag($args, '--status');
                $status = $statusFlag !== null ? Status::from($statusFlag) : null;
                $tasks = $repo->all($status);
                if ($tasks === []) {
                    echo "No tasks found.\n";
                    return 0;
                }
                foreach ($tasks as $task) {
                    echo formatTask($task) . "\n";
                }
                return 0;

            case 'done':
                $id = (int) ($args[0] ?? 0);
                $task = $repo->markDone($id);
                echo "Marked task #{$task->id} as done.\n";
                return 0;

            case 'delete':
                $id = (int) ($args[0] ?? 0);
                $repo->delete($id);
                echo "Deleted task #{$id}.\n";
                return 0;

            case 'stats':
                $stats = $repo->stats();
                echo "Pending: {$stats->pending}  Done: {$stats->done}  Total: {$stats->total()}\n";
                return 0;

            default:
                printUsage();
                return 1;
        }
    } catch (TaskNotFoundException $e) {
        echo "Error: {$e->getMessage()}\n";
        return 1;
    } catch (InvalidArgumentException | ValueError $e) {
        echo "Error: {$e->getMessage()}\n";
        return 1;
    }
}

exit(run($argv));
