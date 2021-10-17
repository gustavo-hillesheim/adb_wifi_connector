Package that implements common functionality for the [app](../app) and [server](../server).

# Functionality implemented
- Socket message handling
- Socket message strings

# Socket Message Handling
Conversations through sockets are done by prefixing the messages with an ID, for example in `1;Hello`, `1` is the ID and `Hello` is the actual message. By using this approach, we can have conversations between the client and server, knowing which message answers which.<br>
The `SocketClient` class handles this, allowing the developer to send message, answer or listen to conversations, and listen to any message at all.