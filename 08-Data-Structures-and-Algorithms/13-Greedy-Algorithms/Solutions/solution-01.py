import importlib.util
import os

_heap_module_path = os.path.join(
    os.path.dirname(__file__), "..", "..", "10-Heaps-and-Priority-Queues", "implementation.py"
)
_spec = importlib.util.spec_from_file_location("heaps_lesson_implementation_ex01", _heap_module_path)
_heaps_module = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_heaps_module)
MinHeap = _heaps_module.MinHeap


def min_meeting_rooms(meetings):
    if not meetings:
        return 0

    sorted_meetings = sorted(meetings, key=lambda meeting: meeting[0])
    end_times = MinHeap()  # tracks the end time of every room currently in use

    for start, end in sorted_meetings:
        if len(end_times) > 0 and end_times.peek() <= start:
            # The room that frees up SOONEST already ended at or before this
            # meeting starts -- reuse it instead of allocating a new room.
            end_times.pop()
        end_times.push(end)

    return len(end_times)  # every remaining entry represents one room still in use


if __name__ == "__main__":
    print(min_meeting_rooms([(0, 30), (5, 10), (15, 20)]), "(expected 2)")
    print(min_meeting_rooms([(7, 10), (2, 4)]), "(expected 1)")
    print(min_meeting_rooms([]), "(expected 0)")
    print(min_meeting_rooms([(1, 5), (2, 6), (3, 7), (4, 8)]), "(expected 4 -- all four overlap simultaneously at time 4)")
    print(min_meeting_rooms([(1, 2), (2, 3), (3, 4)]), "(expected 1 -- back-to-back, never overlapping)")
