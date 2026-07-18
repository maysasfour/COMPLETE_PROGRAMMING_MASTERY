<?php

declare(strict_types=1);

require_once __DIR__ . '/../src/TaskItem.php';
require_once __DIR__ . '/../src/TaskNotFoundException.php';
require_once __DIR__ . '/../src/TaskRepository.php';

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\TestCase;

final class TaskRepositoryTest extends TestCase
{
    private TaskRepository $repo;

    protected function setUp(): void
    {
        // A fresh :memory: connection per test -- SQLite's in-memory database
        // only exists for the lifetime of the connection that opened it, so
        // building a new PDO here (rather than sharing one across tests)
        // guarantees no state leaks between test methods, exactly the
        // discipline Lesson 18's own setUp() establishes.
        $this->repo = new TaskRepository(new PDO('sqlite::memory:'));
    }

    #[Test]
    public function addingATaskDefaultsToPendingAndMediumPriority(): void
    {
        $task = $this->repo->add('Write tests');

        $this->assertSame('Write tests', $task->title);
        $this->assertSame(Priority::Medium, $task->priority);
        $this->assertSame(Status::Pending, $task->status);
        $this->assertSame(1, $task->id);
    }

    #[Test]
    public function addingATaskWithAnEmptyTitleThrows(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('Task title must not be empty.');

        $this->repo->add('   ');
    }

    #[Test]
    #[DataProvider('priorityCases')]
    public function addingATaskAcceptsEachPriority(Priority $priority, string $expectedLabel): void
    {
        $task = $this->repo->add('Priority check', $priority);

        $this->assertSame($priority, $task->priority);
        $this->assertSame($expectedLabel, $task->priority->label());
    }

    public static function priorityCases(): array
    {
        return [
            'low priority' => [Priority::Low, 'Low'],
            'medium priority' => [Priority::Medium, 'Medium'],
            'high priority' => [Priority::High, 'High'],
        ];
    }

    #[Test]
    public function allReturnsTasksInInsertionOrder(): void
    {
        $this->repo->add('First');
        $this->repo->add('Second');
        $this->repo->add('Third');

        $titles = array_map(fn (TaskItem $t) => $t->title, $this->repo->all());

        $this->assertSame(['First', 'Second', 'Third'], $titles);
    }

    #[Test]
    public function allCanFilterByStatus(): void
    {
        $first = $this->repo->add('Pending one');
        $second = $this->repo->add('Will be done');
        $this->repo->markDone($second->id);

        $pending = $this->repo->all(Status::Pending);
        $done = $this->repo->all(Status::Done);

        $this->assertCount(1, $pending);
        $this->assertSame($first->id, $pending[0]->id);
        $this->assertCount(1, $done);
        $this->assertSame($second->id, $done[0]->id);
    }

    #[Test]
    public function findReturnsTheMatchingTask(): void
    {
        $created = $this->repo->add('Findable');

        $found = $this->repo->find($created->id);

        $this->assertSame($created->title, $found->title);
    }

    #[Test]
    public function findingAMissingIdThrowsTaskNotFoundException(): void
    {
        $this->expectException(TaskNotFoundException::class);
        $this->expectExceptionMessage('No task found with id 999.');

        $this->repo->find(999);
    }

    #[Test]
    public function markDoneFlipsStatusAndReturnsTheUpdatedTask(): void
    {
        $task = $this->repo->add('Flip me');

        $updated = $this->repo->markDone($task->id);

        $this->assertSame(Status::Done, $updated->status);
        // The original TaskItem instance is untouched -- TaskItem is
        // immutable, so markDone() had to hand back a NEW object rather
        // than mutating the one already held by the caller.
        $this->assertSame(Status::Pending, $task->status);
    }

    #[Test]
    public function markDoneOnAMissingIdThrowsTaskNotFoundException(): void
    {
        $this->expectException(TaskNotFoundException::class);

        $this->repo->markDone(42);
    }

    #[Test]
    public function deleteRemovesTheTask(): void
    {
        $task = $this->repo->add('Delete me');

        $this->repo->delete($task->id);

        $this->expectException(TaskNotFoundException::class);
        $this->repo->find($task->id);
    }

    #[Test]
    public function deleteOnAMissingIdThrowsTaskNotFoundException(): void
    {
        $this->expectException(TaskNotFoundException::class);

        $this->repo->delete(7);
    }

    #[Test]
    public function statsCountsPendingAndDoneSeparately(): void
    {
        $a = $this->repo->add('A');
        $this->repo->add('B');
        $this->repo->markDone($a->id);

        $stats = $this->repo->stats();

        $this->assertSame(1, $stats->pending);
        $this->assertSame(1, $stats->done);
        $this->assertSame(2, $stats->total());
    }

    #[Test]
    public function statsOnAnEmptyRepositoryIsAllZero(): void
    {
        $stats = $this->repo->stats();

        $this->assertSame(0, $stats->pending);
        $this->assertSame(0, $stats->done);
        $this->assertSame(0, $stats->total());
    }
}
