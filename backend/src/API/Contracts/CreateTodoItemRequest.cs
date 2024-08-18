namespace API.Contracts;

public record CreateTodoItemRequest(string Title, string Description, bool IsComplete);
