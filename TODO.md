# To be done
_________

- Check if any concurrent-ruby primitives might be used to improve the current implementation.
- Ensure fault-tolerance in the whole stack.
- Add Event ACK/Recovery.
- Terminate inactive aggregates on a configurable timeout.
- Implement more Event::Store backends (MongoDB, PostgreSQL)

# To be considered
---------

- Add a mandatory id/stream_id/aggregate_id field to commands.
- Specific implementation of Sagas and Projections.
- Allow Event::Subscriber to subscribe only to events defined under a common application namespace.